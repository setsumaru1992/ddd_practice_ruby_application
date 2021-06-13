module Domain::Person::Group
  class Factory < ::Domain::Base::Factory
    class << self
      def build(group_name, accessible_user_id_param, parent_group_id_param)
        group = Group.empty_build

        group.name = Name.new(group_name)
        group.accessible_user_id = ::Domain::Auth::User::Repository.build_id_from_id_param(accessible_user_id_param)

        group.parent_group_id = Repository.build_id_from_id_param(parent_group_id_param) if parent_group_id_param.present?

        group
      end
    end
  end
end