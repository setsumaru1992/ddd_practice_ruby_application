module Domain::Person
  class Repository < ::Domain::Base::Repository
    class << self
      def find(id)
        person_record = ::Person.find_by(id: id.value)
        return if person_record.blank?

        id = build_value_object_from_model(person_record, Id)

        person_name_record = ::PersonName.find_by(person_id: person_record.id)
        name = build_value_object_from_model(person_name_record, Name)

        person_sex_record = ::PersonSex.find_by(person_id: person_record.id)
        sex = build_value_object_from_model(person_sex_record, Sex)

        person_birthdate_record = ::PersonBirthdate.find_by(person_id: person_record.id)
        birthdate = build_value_object_from_model(person_birthdate_record, Birthdate)

        person_group_belonging_record = ::PersonGroupBelonging.find_by(person_id: person_record.id)
        person_group_id = build_value_object_from_model(person_group_belonging_record, ::Domain::Person::Group::Id)

        accessible_user_id = find_accessible_user_id(id)

        Person.new(id, name, sex, birthdate, person_group_id, accessible_user_id)
      end

      def find_by_id_param(id_param)
        person_id = Id.new(fetch_id_value_from_id_param(id_param), id_param)
        find(person_id)
      end

      def add(person)
        add_person(person, user_self_person: false)
      end

      def add_user_self_person(person)
        add_person(person, user_self_person: true)
      end

      def add_person(person, user_self_person: false)
        raise "既にレコードが存在します。" if person.id.any_value_present?

        ActiveRecord::Base.transaction do
          person_record = resister_person(person)
    
          resister_person_group_relation(person, person_record) if person.person_group_id.present_value?
          resister_user_person_relation(person, person_record, user_self_person: user_self_person)
          Id.build_by_record(person_record)
        end
      end

      def update(person)
        person_record = ::Person.find_by(id: person.id.value)
        raise "更新するレコードが存在しません。" if person_record.blank?

        ActiveRecord::Base.transaction do
          update_person(person, person_record)
          update_person_group_relation(person, person_record) if person.person_group_id.changed_fields.present?
        end
      end

      def remove(person)
        person_record = ::Person.find_by(id: person.id.value)
        raise "削除するレコードが存在しません" if person_record.blank?

        ActiveRecord::Base.transaction do
          remove_person_group_relation(person_record.id)
          remove_user_person_relation(person_record.id)
          remove_person(person_record)
        end
      end

      def build_id_from_id_param(id_param)
        id_value = fetch_id_value_from_id_param(id_param)
        raise "指定したグループが存在しません。" if id_value.nil?

        Id.new(id_value, id_param)
      end

      def fetch_id_value_from_id_param(id_param)
        ::Person.find_by(id_param: id_param)&.id
      end

      def fetch_person_record(id)
        return id.fetched_record if id.fetched_record.present?

        person_record = ::Person.find_by(id: id.value)
        id.fetched_record = person_record
        person_record
      end

      def find_accessible_user_id(person_id)
        user_person_relation = ::UserPersonRelation.find_by(person_id: person_id.value)
        user_id_value = user_person_relation.user_id
        ::Domain::Auth::User::Repository.build_id_from_id_value(user_id_value)
      end

      def judge_that_person_is_user_self_person(person_id)
        ::UserPersonMapping.where(person_id: person_id.value).present?
      end

      private

      def build_value_object_from_model(model, value_object_class)
        if model.present?
          value_object_class.build_from_model(model)
        else
          nil
        end
      end

      def resister_person(person)
        person_record = ::Person.new
        person_record.id_param = generate_unique_id_param
        person_record.save!

        resister_person_name(person.name, person_record)
        resister_person_sex(person.sex, person_record) if person.sex.present_value?
        resister_person_birthdate(person.birthdate, person_record) if person.birthdate.present_value?

        person_record
      end

      def update_person(person, person_record)
        update_person_name(person.name, person_record) if person.name.changed_fields.present?
        update_person_sex(person.sex, person_record) if person.sex.changed_fields.present?
        update_person_birthdate(person.birthdate, person_record) if person.birthdate.changed_fields.present?
      end

      def remove_person(person_record)
        remove_person_name(person_record.id)
        remove_person_sex(person_record.id)
        remove_person_birthdate(person_record.id)

        person_record.destroy!
      end

      def generate_unique_id_param
        id = Id.build_empty_object
        loop do
          id_param = id.generate_id_param
          record_with_param = ::Person.find_by(id_param: id_param)
          return id_param if record_with_param.blank?
        end
      end

      def resister_person_name(person_name, person_record)
        name_record = ::PersonName.new
        name_record.person = person_record
        name_record = set_name_fields_into_model(person_name, name_record)
        name_record.save!
        name_record
      end

      def update_person_name(person_name, person_record)
        existing_name_record = ::PersonName.find_by(person: person_record)

        if existing_name_record.nil?
          resister_person_name(person_name, person_record)
          return
        end

        if existing_name_record.present? && person_name.nil_value?
          remove_person_name(person_record.id)
          return
        end

        name_record = existing_name_record
        name_record = set_name_fields_into_model(person_name, name_record)
        name_record.save!
      end

      def set_name_fields_into_model(person_name, name_record)
        set_same_name_fields_into_model(person_name, name_record, [:disp_name, :last_name, :first_name, :middle_name, :kana])
      end

      def remove_person_name(person_id_value)
        ::PersonName.find_by(person_id: person_id_value)&.destroy!
      end

      def resister_person_sex(person_sex, person_record)
        sex_record = ::PersonSex.new
        sex_record.person = person_record
        sex_record = set_sex_fields_into_model(person_sex, sex_record)
        sex_record.save!
        sex_record
      end

      def update_person_sex(person_sex, person_record)
        existing_sex_record = ::PersonSex.find_by(person: person_record)

        if existing_sex_record.nil?
          resister_person_sex(person_sex, person_record)
          return
        end

        if existing_sex_record.present? && person_sex.nil_value?
          remove_person_sex(person_record.id)
          return
        end

        sex_record = existing_sex_record
        sex_record = set_sex_fields_into_model(person_sex, sex_record)
        sex_record.save!
      end

      def set_sex_fields_into_model(person_sex, sex_record)
        set_same_name_fields_into_model(person_sex, sex_record, [:birth_sex_code, :desired_sex_code])
      end

      def remove_person_sex(person_id_value)
        ::PersonSex.find_by(person_id: person_id_value)&.destroy!
      end

      def resister_person_birthdate(person_birthdate, person_record)
        birthdate_record = ::PersonBirthdate.new
        birthdate_record.person = person_record
        birthdate_record = set_birthdate_fields_into_model(person_birthdate, birthdate_record)
        birthdate_record.save!
        birthdate_record
      end

      def update_person_birthdate(person_birthdate, person_record)
        existing_birthdate_record = ::PersonBirthdate.find_by(person: person_record)

        if existing_birthdate_record.nil?
          resister_person_birthdate(person_birthdate, person_record)
          return
        end

        if existing_birthdate_record.present? && person_birthdate.nil_value?
          remove_person_birthdate(person_record.id)
          return
        end

        birthdate_record = existing_birthdate_record
        birthdate_record = set_birthdate_fields_into_model(person_birthdate, birthdate_record)
        birthdate_record.save!
      end

      def set_birthdate_fields_into_model(person_birthdate, birthdate_record)
        set_same_name_fields_into_model(person_birthdate, birthdate_record, [:year, :month, :date])
      end

      def remove_person_birthdate(person_id_value)
        ::PersonBirthdate.find_by(person_id: person_id_value)&.destroy!
      end

      def set_same_name_fields_into_model(value_object, value_record, field_names)
        field_names.each do |field|
          value_record[field] = value_object[field]
        end
        value_record
      end

      def resister_person_group_relation(person, person_record)
        person_group_belonging_record = ::PersonGroupBelonging.new
        person_group_belonging_record.person = person_record
        person_group_belonging_record.person_group = ::PersonGroup.find(person.person_group_id.value)
        person_group_belonging_record.save!
      end

      def update_person_group_relation(person, person_record)
        existing_person_group_belonging_record = ::PersonGroupBelonging.find_by(person: person_record)

        if existing_person_group_belonging_record.nil?
          resister_person_group_relation(person, person_record)
          return
        end

        if existing_person_group_belonging_record.present? && person.person_group_id.nil_value?
          remove_person_group_relation(person_record.id)
          return
        end

        person_group_belonging_record = existing_person_group_belonging_record
        person_group_belonging_record.person_group = ::PersonGroup.find(person.person_group_id.value)
        person_group_belonging_record.save!
      end

      def remove_person_group_relation(person_id_value)
        ::PersonGroupBelonging.find_by(person_id: person_id_value)&.destroy!
      end

      def resister_user_person_relation(person, person_record, user_self_person: false)
        user_record = ::User.find(person.accessible_user_id.value)

        user_person_relation_record = ::UserPersonRelation.new
        user_person_relation_record.person = person_record
        user_person_relation_record.user = user_record
        user_person_relation_record.save!

        return unless user_self_person

        user_person_mapping_record = ::UserPersonMapping.new
        user_person_mapping_record.person = person_record
        user_person_mapping_record.user = user_record
        user_person_mapping_record.save!
      end

      def remove_user_person_relation(person_id_value)
        ::UserPersonRelation.find_by(person_id: person_id_value).destroy!
        ::UserPersonMapping.find_by(person_id: person_id_value)&.destroy!
      end
    end
  end
end