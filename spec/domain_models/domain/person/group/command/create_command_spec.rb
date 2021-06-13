# frozen_string_literal: true

require "rails_helper"
require_relative "../repository/repository_add_shared_examples"

RSpec.describe ::Domain::Person::Group::Command::CreateCommand do
  describe ".calls" do
    let(:accessible_user_id_param) { user_record.id_param }

    context "when create top group," do
      let(:group_name) { "東京中央銀行" }

      let!(:new_group) do
        described_class.call(
          name: group_name,
          accessible_user_id_param: accessible_user_id_param,
        )
      end
      
      let(:new_group_name) { group_name }
      let(:new_group_id_value) { new_group.id.value }
      include_examples "new group and its relation should be created as top group"
    end

    context "when create group under top," do
      let(:group_name) { "融資課" }

      let!(:new_group) do
        described_class.call(
          name: group_name,
          accessible_user_id_param: accessible_user_id_param,
          parent_group_id_param: parent_group_record.id_param,
        )
      end
      
      let(:new_group_name) { group_name }
      let(:new_group_id_value) { new_group.id.value }
      include_examples "new group and its relation should be created under some group"
    end
  end
end