# frozen_string_literal: true

require "rails_helper"
require_relative "../repository/repository_update_shared_examples"

RSpec.describe ::Domain::Person::Group::Command::UpdateCommand do
  describe ".calls" do
    context "when not update every field(required field only)," do
      include_examples "set up group relation record for test top group"

      before do
        described_class.call(id_param: existing_group_record.id_param)
      end

      it_behaves_like "group relation information should not be updated"
    end

    context "when update name and update relation under some group -> under some other group," do
      include_examples "set up group relation record for test child group"
      let(:updated_group_name) { "沖縄中央銀行" }

      before do
        described_class.call(
          id_param: existing_group_record.id_param,
          name: updated_group_name,
          parent_group_id_param: another_no_parent_person_group_record.id_param
        )
      end

      it_behaves_like "group information should be updated except relation"
      it_behaves_like "group information should be updated as under different group"
    end

    # 本来上記で最低限引数・最大限引数のテストは終わっているが、parent_group_id_param:nilのときにエラーが起きたときがあったために念の為追加
    context "when update relation under some group -> top," do
      include_examples "set up group relation record for test child group"

      before do
        described_class.call(
          id_param: existing_group_record.id_param,
          parent_group_id_param: nil
        )
      end

      it_behaves_like "group information should be updated as under some group -> top"
    end
  end
end