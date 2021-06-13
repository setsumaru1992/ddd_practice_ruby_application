module Domain::Person::Group
  class Command::CreateCommand < Domain::Base::Command
    attribute :name, :string
    validates :name, presence: true

    attribute :accessible_user_id_param, :string
    validates :accessible_user_id_param, presence: true

    attribute :parent_group_id_param, :string

    def call
      group = Factory.build(name, accessible_user_id_param, parent_group_id_param)
      group.id = Repository.add(group)
      group
    end
  end
end