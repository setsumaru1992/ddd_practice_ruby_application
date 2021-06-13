module Domain::Person::Group
  class Command::RemoveCommand < Domain::Base::Command
    attribute :id_param, :string
    validates :id_param, presence: true

    def call
      existing_group = Repository.find_by_id_param(id_param)
      
      if Repository.with_any_children?(existing_group.id)
        return RemoveCommandResult.build_as_cannot_remove_due_to_having_child_group
      end
      
      if Repository.with_any_people?(existing_group.id)
        return RemoveCommandResult.build_as_cannot_remove_due_to_having_person
      end

      Repository.remove(existing_group)
      RemoveCommandResult.build_success_result
    end

    class RemoveCommandResult < ::Domain::Base::CommandResult
      STATUS_CANNOT_REMOVE_DUE_TO_HAVING_CHILD_GROUP = "STATUS_CANNOT_REMOVE_DUE_TO_HAVING_CHILD_GROUP"
      STATUS_CANNOT_REMOVE_DUE_TO_HAVING_PERSON = "STATUS_CANNOT_REMOVE_DUE_TO_HAVING_PERSON"

      class << self
        def build_as_cannot_remove_due_to_having_child_group
          new(
            status: STATUS_CANNOT_REMOVE_DUE_TO_HAVING_CHILD_GROUP,
            error: "子グループがいるために削除できません。"
          )
        end
        
        def build_as_cannot_remove_due_to_having_person
          new(
            status: STATUS_CANNOT_REMOVE_DUE_TO_HAVING_PERSON,
            error: "属している人がいるため削除できません。"
          )
        end
      end
    end
  end
end