module Domain::Person::Group
  class Finder::FetchGroupsFinderWithHierarchy < ::Domain::Base::Finder
    attribute :access_user_id, :integer
    validates :access_user_id, presence: true

    attribute :limit_layer_depth, :integer

    def fetch
      hierarchy_records = ::PersonGroupHierarchy.filter_user_accessible_person_group(access_user_id)
      converted_hierarchy_records = convert_records_for_hierarchy_hash_builder(hierarchy_records)
      HierarchyHashBuilder.call(converted_hierarchy_records, limit_layer_depth)
    end

    private

    def convert_records_for_hierarchy_hash_builder(hierarchy_records)
      hierarchy_records.map do |hierarchy_record|
        hierarchy_field_values_with_layer_name = hierarchy_record.attributes.reject {|field, _| [:user_id].include?(field.to_sym)}
        
        layer_values_with_layer_name = hierarchy_field_values_with_layer_name.group_by {|field_name, value| "#{field_name.to_s.split("_")[0]}_group"}
        
        layer_values_with_layer_name.map do |layer_name, layer_field_values_with_layer_name|
          layer_values = layer_field_values_with_layer_name.map do |field_name_with_layer_name, value|
            field_name = field_name_with_layer_name.match("#{layer_name.to_s}_(.*)")[1].to_sym
            [field_name, value]
          end.to_h

          [
            layer_name.to_sym,
            layer_values
          ]
        end.to_h
      end
    end

    class HierarchyHashBuilder
      class << self
        # ※単純さの観点からidとid_paramは省略。グルーピングのキーは本当はid_paramだが、例ではnameのようにを使用
        # 入力データ例(ここ自体もっとよくできるかも。改善する場合はN+1問題に注意)
        # [
        #   {
        #     top: {name: "ぶどう"},
        #     middle: {name: "巨峰"},
        #     bottom: nil
        #   },
        #   {
        #     top: {name: "ぶどう"},
        #     middle: {name: "シャインマスカット"},
        #     bottom: nil
        #   },
        #   {
        #     top: {name: "りんご"},
        #     middle: {name: "ふじ"},
        #     bottom: nil
        #   },
        #   {
        #     top: {name: "いちじく"},
        #     middle: nil,
        #     bottom: nil
        #   },
        # ]
        # 出力データ例(与えるブロックによりchildren以外の出力を変更可能)
        # [
        #   {
        #     name: "ぶどう",
        #     children: [
        #       {
        #         name: "巨峰",
        #         children: nil
        #       },
        #         name: "シャインマスカット",
        #         children: nil
        #       },
        #     ]
        #   },
        #   {
        #     name: "りんご",
        #     children: [
        #       {
        #         name: "ふじ",
        #         children: nil
        #       },
        #     ]
        #   },
        #   {
        #     name: "いちじく",
        #     children: nil
        #   },
        # ]
        def call(hierarchy_relations, limit_layer_depth)
          layers = [:top_group, :middle_group, :bottom_group]
          limit_layer_depth ||= layers.size
          ::Assert.assert(limit_layer_depth <= layers.size)

          difference_between_actual_and_want_depth = layers.length - limit_layer_depth
          layers_index_from_last = (-1) - difference_between_actual_and_want_depth

          group_by_same_person_group_on_same_layer_recursively(
            hierarchy_relations,
            layers.first,
            layers.slice(1..layers_index_from_last)
          )
        end

        private
        
        def group_by_same_person_group_on_same_layer_recursively(hierarchy_relations, current_layer, next_layers)
          return nil if current_layer.blank?
          return nil if hierarchy_relations.first&.attributes&.fetch(current_layer, nil)&.fetch(:id, nil).blank?

          hierarchy_relations_group_by_same_person_group = hierarchy_relations.group_by{|hierarchy_relation| hierarchy_relation[current_layer][:id]}

          hierarchy_relations_group_by_same_person_group.map do |group_id, person_groups_with_grouped_person_group|
            person_group = person_groups_with_grouped_person_group.first[current_layer].dup
            person_group[:children] = group_by_same_person_group_on_same_layer_recursively(
              person_groups_with_grouped_person_group,
              next_layers.first,
              next_layers.slice(1..-1)
            )
            person_group
          end
        end
      end
    end
  end
end