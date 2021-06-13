module Domain::Person::Group
  class Repository < ::Domain::Base::Repository
    class << self
      def find_by_id_param(id_param)
        id = build_id_from_id_param(id_param)
        find(id)
      end

      def find(group_id)
        group_record = ::PersonGroup.find_by(id: group_id.value)

        return if group_record.blank?

        group_relation_record = ::PersonGroupRelation.find_by(child_person_group: group_record)
        parent_id = if group_relation_record.present?
          parent_group_record = group_relation_record.person_group
          Id.new(parent_group_record.id, parent_group_record.id_param)
        end

        Group.new(
          Id.new(group_record.id, group_record.id_param), 
          Name.new(group_record.name),
          parent_id,
          find_accessible_user_id(group_id),
        )
      end

      def find_accessible_user_id(group_id)
        hierarchy = PersonGroupHierarchy.contain_group(group_id.value).first
        user_id_value = hierarchy.user_id
        ::Domain::Auth::User::Repository.build_id_from_id_value(user_id_value)
      end

      def build_id_from_id_param(id_param)
        id_value = fetch_id_value_from_id_param(id_param)
        raise "指定したグループが存在しません。" if id_value.nil?

        Id.new(id_value, id_param)
      end

      def fetch_id_value_from_id_param(id_param)
        ::PersonGroup.find_by(id_param: id_param)&.id
      end

      def with_any_children?(group_id)
        ::PersonGroup.find_by(id: group_id.value).children.present?
      end

      def with_any_people?(group_id)
        ::PersonGroupBelonging.where(person_group_id: group_id.value).present?
      end

      def add(group)
        raise "既にレコードが存在します。" if group.id.any_value_present?

        ActiveRecord::Base.transaction do
          group_record = register_group(group)
          register_group_hierarcky(group, group_record)

          Id.build_by_record(group_record)
        end
      end

      def update(group)
        group_record = ::PersonGroup.find_by(id: group.id.value)
        raise "更新するレコードが存在しません。" if group_record.blank?

        ActiveRecord::Base.transaction do
          update_group(group, group_record)

          update_group_hierarchy(group, group_record)
        end
      end

      def remove(group)
        group_record = ::PersonGroup.find_by(id: group.id.value)
        raise "削除するレコードが存在しません。" if group_record.blank?

        ActiveRecord::Base.transaction do
          remove_group_hierarchy(group_record)
          # TODO: 人がグループに登録されるようになったら人の削除関連処理を追加

          group_record.destroy!
        end
      end

      private

      def generate_unique_id_param
        id = Id.build_empty_object
        loop do
          id_param = id.generate_id_param
          record_with_param = PersonGroup.find_by(id_param: id_param)
          return id_param if record_with_param.blank?
        end
      end

      def register_group(group)
        group_record = ::PersonGroup.new
        group_record.id_param = generate_unique_id_param
        group_record.name = group.name.value
        group_record.save!
        group_record
      end

      def update_group(group, group_record)
        return unless group.changed_fields.keys.include?(:name)

        group_record.name = group.name.value
        group_record.save!
      end

      def register_group_hierarcky(group, group_record)
        if group.parent_group_id.present_value?
          register_person_group_relation(group.parent_group_id.value, group_record.id)
        else
          register_top_group_relation_records(group, group_record)
        end
      end

      # |           | 更新後親なし              | 更新後親あり                     |
      # | ---       | ---                      | ---                            |
      # | 既存親なし | noop                     | 階層作成 & topデータ削除         |
      # | 既存親あり | 階層削除 & topデータ作成   | 変化なし:noop / 変化あり:階層変更 |
      def update_group_hierarchy(group, group_record)
        existing_parent_group_id_value = group_record.parent&.id
        updated_parent_group_id_value = group.parent_group_id&.value
        
        existing_child_group_id_value = group_record.id
 
        # 既存親なし & 更新後親なし
        return if existing_parent_group_id_value.blank? && updated_parent_group_id_value.blank?
        
        # 既存親なし & 更新後親あり
        if existing_parent_group_id_value.blank? && updated_parent_group_id_value.present?
          remove_top_group_relation_records(group_record)
          register_person_group_relation(updated_parent_group_id_value, existing_child_group_id_value)
          return
        end
       
        # 既存親あり & 更新後親なし
        if existing_parent_group_id_value.present? && updated_parent_group_id_value.blank?
          remove_person_group_relation(existing_child_group_id_value)
          register_top_group_relation_records(group, group_record)
          return
        end

        # 既存親あり & 更新後親あり
        return unless existing_parent_group_id_value.present? && updated_parent_group_id_value.present?
        # 変化なし
        return if existing_parent_group_id_value == updated_parent_group_id_value

        # 変化あり
        # 階層変更
        change_parent_of_person_group_relation(existing_child_group_id_value, updated_parent_group_id_value)
      end

      def remove_group_hierarchy(group_record)
        if group_record.parent&.id.present?
          remove_person_group_relation(group_record.id)
        else
          remove_top_group_relation_records(group_record)

          if group_record.children.present?
            remove_person_group_relation_by_parent(group_record)
          end
        end
      end

      def register_person_group_relation(parent_id_value, child_group_id_value)
        group_relation_record = ::PersonGroupRelation.new
        group_relation_record.person_group_id = parent_id_value
        group_relation_record.child_person_group_id = child_group_id_value
        group_relation_record.save!
      end

      def change_parent_of_person_group_relation(child_group_id_value, new_parent_id_value)
        group_relation_record = existing_person_group_relation_by_child(child_group_id_value)
        group_relation_record.person_group_id = new_parent_id_value
        group_relation_record.save!
      end

      def remove_person_group_relation(child_group_id_value)
        group_relation_record = existing_person_group_relation_by_child(child_group_id_value)
        group_relation_record.destroy! if group_relation_record.present?
      end

      def remove_person_group_relation_by_parent(parent_group_record)
        group_relation_records = ::PersonGroupRelation.where(person_group_id: parent_group_record.id)
        group_relation_records.map(&:destroy!)
        
        parent_group_record.children.map(&:destroy!)
      end

      def existing_person_group_relation_by_child(child_person_group_id)
        relation = ::PersonGroupRelation.where(child_person_group_id: child_person_group_id)
        relation.size == 1 ? relation.first : nil
      end

      def register_top_group_relation_records(group, group_record)
        top_group_record = ::TopPersonGroup.new
        top_group_record.person_group = group_record
        top_group_record.save!

        user_accessible_group_record = ::UserAccessibleTopPersonGroup.new
        user_accessible_group_record.user = ::User.find(group.accessible_user_id.value)
        user_accessible_group_record.top_person_group = top_group_record
        user_accessible_group_record.save!
      end

      def remove_top_group_relation_records(group_record)
        top_group_record = ::TopPersonGroup.where(person_group_id: group_record.id)&.first
        user_accessible_group_record = ::UserAccessibleTopPersonGroup.where(top_person_group_id: group_record.id)&.first

        user_accessible_group_record.destroy! if user_accessible_group_record.present?
        top_group_record.destroy! if top_group_record.present?
      end
    end
  end
end