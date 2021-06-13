module Domain::Person::Group
  class Finder::BuildIdParamAndLabelSetsForSelectbox < Finder::FetchGroupsFinderWithHierarchy
    def fetch
      groups_with_hierarchy = super
      @sets_for_selectbox = []
      build_id_param_and_label_set_recursively(groups_with_hierarchy)
      @sets_for_selectbox
    end

    private

    def build_id_param_and_label_set_recursively(groups_with_hierarchy, depth = 1)
      return if groups_with_hierarchy.nil?

      groups_with_hierarchy.each do |group_with_hierarchy|
        @sets_for_selectbox << build_id_param_and_label_set(group_with_hierarchy, depth)
        build_id_param_and_label_set_recursively(group_with_hierarchy[:children], depth + 1)
      end
    end

    def build_id_param_and_label_set(group_with_hierarchy, depth)
      indent = "　" * (depth - 1)
      label = "#{indent}> #{group_with_hierarchy[:name]}"
      [label, group_with_hierarchy[:id_param]]
    end
  end
end