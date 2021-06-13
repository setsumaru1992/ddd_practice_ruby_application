# frozen_string_literal: true

require "rails_helper"
require_relative "../repository/repository_remove_shared_examples"

RSpec.describe ::Domain::Person::Command::RemoveCommand do
  describe ".calls" do
    context "when remove user self person, " do
      include_context "set up user self person for remove"

      let!(:result){described_class.call(id_param: existing_person_record.id_param)}
      it "delete succeeded" do
        expect(result.status).to be Domain::Person::Command::RemoveCommand::RemoveCommandResult::STATUS_CANNOT_REMOVE_DUE_TO_BEING_USER_SELF_PERSON
      end
    end

    context "when remove not user self person, " do
      include_context "set up person with essential fields record for remove"

      let!(:result){described_class.call(id_param: existing_person_record.id_param)}
      it "delete succeeded" do
        expect(result.status).to be Domain::Person::Command::RemoveCommand::RemoveCommandResult::STATUS_SUCCESS
      end
      it_behaves_like "person should be removed completely"
    end
  end
end
