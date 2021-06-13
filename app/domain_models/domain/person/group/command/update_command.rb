module Domain::Person::Group
  class Command::UpdateCommand < Domain::Base::Command
    attribute :id_param, :string
    validates :id_param, presence: true

    attribute :name, :string

    attribute :parent_group_id_param, :string

    def call
      existing_group = Repository.find_by_id_param(id_param)
      updated_group = update_fields(existing_group)
      Repository.update(updated_group)
    end

    private

    def update_fields(group)
      updated_name = Name.new(name)
      group.update_name(updated_name) if group.name != updated_name

      parent_group_id = if parent_group_id_param.present?
        Repository.build_id_from_id_param(parent_group_id_param)
      end
      if group.parent_group_id != parent_group_id
        group.update_parent_group_id(parent_group_id)
      end

      group
    end
  end
end