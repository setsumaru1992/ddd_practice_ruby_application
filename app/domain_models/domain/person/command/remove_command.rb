module Domain::Person
  class Command::RemoveCommand < Domain::Base::Command
    attribute :id_param, :string
    validates :id_param, presence: true

    def call
      existing_person = Repository.find_by_id_param(id_param)
      # NOTE: ユーザ自身のPersonはユーザ削除時でないと消せない
      if Repository.judge_that_person_is_user_self_person(existing_person.id)
        return RemoveCommandResult.build_as_cannot_remove_due_to_being_user_self_person
      end

      Repository.remove(existing_person)
      RemoveCommandResult.build_success_result
    end

    class RemoveCommandResult < ::Domain::Base::CommandResult
      STATUS_CANNOT_REMOVE_DUE_TO_BEING_USER_SELF_PERSON = "STATUS_CANNOT_REMOVE_DUE_TO_BEING_USER_SELF_PERSON"

      class << self
        def build_as_cannot_remove_due_to_being_user_self_person
          new(
            status: STATUS_CANNOT_REMOVE_DUE_TO_BEING_USER_SELF_PERSON,
            error: "ユーザー自身のため削除できません"
          )
        end
      end
    end
  end
end