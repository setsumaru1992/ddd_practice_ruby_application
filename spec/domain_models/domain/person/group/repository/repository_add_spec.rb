# frozen_string_literal: true

require "rails_helper"
require_relative "./repository_add_shared_examples"

RSpec.describe ::Domain::Person::Group::Repository do
  describe ".add" do
    context "when add exist group," do
      let!(:person_group) { FactoryBot.create(:person_group) }
      let(:group) do
        group = ::Domain::Person::Group::Group.empty_build
        group.id = ::Domain::Person::Group::Id.new(person_group.id, person_group.id_param)
        group
      end
      
      it "updated as under another group" do
        expect{described_class.add(group)}.to raise_error(StandardError)
      end
    end

    context "when add top group," do
      let(:group_name) { "東京中央銀行" }
      let(:accessible_user_id_param) { user_record.id_param }
      let(:group) { ::Domain::Person::Group::Factory.build(group_name, accessible_user_id_param, nil) }

      let!(:new_group_id) { described_class.add(group) }
      
      let(:new_group_name) { group_name }
      let(:new_group_id_value) { new_group_id.value }
      include_examples "new group and its relation should be created as top group"
    end

    context "when add group under top," do
      let(:top_group_record) { FactoryBot.create(:person_group) }
      let(:group_name) { "融資課" }
      let(:group) do
        ::Domain::Person::Group::Factory.build(
          group_name,
          user_record.id_param,
          parent_group_record.id_param
        )
      end

      let!(:new_group_id) { described_class.add(group) }

      let(:new_group_name) { group_name }
      let(:new_group_id_value) { new_group_id.value }
      include_examples "new group and its relation should be created under some group"
    end
  end
end