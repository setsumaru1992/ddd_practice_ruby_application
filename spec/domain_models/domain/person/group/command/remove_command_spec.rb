# frozen_string_literal: true

require "rails_helper"
require_relative "../repository/repository_remove_shared_examples"

RSpec.describe ::Domain::Person::Group::Command::RemoveCommand do
  describe ".calls" do
    context "when delete simple group," do
      include_context "set up group relation record for test child group for remove"

      let!(:result){described_class.call(id_param: existing_group_record.id_param)}

      it "delete succeeded" do
        expect(result.status).to be Domain::Person::Group::Command::RemoveCommand::RemoveCommandResult::STATUS_SUCCESS
      end
      it_behaves_like "group relation information should be removed complately"
    end
    
    context "when delete group with child group," do
      # 仕様を決めるのが面倒だから、暫定的に子がいる場合の削除を禁止。
      # 仕様決まったらそれに合わせて決める
      include_context "set up group relation record for test top group for remove"

      let!(:result){described_class.call(id_param: existing_group_record.id_param)}

      it "not deleted" do
        expect(result.status).to be Domain::Person::Group::Command::RemoveCommand::RemoveCommandResult::STATUS_CANNOT_REMOVE_DUE_TO_HAVING_CHILD_GROUP
      end
    end
    
    context "when delete group with person," do
      # 仕様を決めるのが面倒だから、暫定的にPersonがいる場合の削除を禁止。
      # 仕様決まったらそれに合わせて決める
      include_context "set up group relation record for test child group with person for remove"

      let!(:result){described_class.call(id_param: existing_group_record.id_param)}

      it "not deleted" do
        expect(result.status).to be Domain::Person::Group::Command::RemoveCommand::RemoveCommandResult::STATUS_CANNOT_REMOVE_DUE_TO_HAVING_PERSON
      end
    end
  end
end