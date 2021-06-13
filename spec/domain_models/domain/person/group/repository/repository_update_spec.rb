# frozen_string_literal: true

require "rails_helper"
require_relative "./repository_update_shared_examples"

RSpec.describe ::Domain::Person::Group::Repository do
  describe ".update" do
    context "when update not exist group," do
      include_context "set up group relation record for test top group"
      let(:group) do
        group = ::Domain::Person::Group::Group.empty_build
        group.id = ::Domain::Person::Group::Id.new(4444, "notexist")
        group
      end
      
      it "updated as under another group" do
        expect{described_class.update(group)}.to raise_error(StandardError)
      end
    end
    
    context "when update only group information(not affect relation)," do
      include_context "set up group relation record for test top group"

      let(:updated_group_name) { "沖縄中央銀行" }
      let(:group) do
        group = ::Domain::Person::Group::Repository.find_by_id_param(existing_group_record.id_param)
        group.update_name(updated_group_name)
        group
      end

      before do
        described_class.update(group)
      end
      
      include_examples "group information should be updated except relation"
    end
    
    context "when update group relation top -> top(no change)," do
      include_context "set up group relation record for test top group"
      let(:group){::Domain::Person::Group::Repository.find_by_id_param(existing_group_record.id_param)}

      before do
        described_class.update(group)
      end

      it_behaves_like "group relation information should not be updated"
    end
    
    context "when update group relation top -> under some group," do
      include_context "set up group relation record for test top group"
      
      let(:group) do
        group = ::Domain::Person::Group::Repository.find_by_id_param(existing_group_record.id_param)
        group.parent_group_id = ::Domain::Person::Group::Repository.build_id_from_id_param(another_no_parent_person_group_record.id_param)
        group
      end

      before do
        described_class.update(group)
      end

      let(:existing_group_id_value) { existing_group_record.id }
      let(:old_group_relation_record) { ::PersonGroupRelation.where(person_group_id: existing_group_id_value) }
      let(:new_group_relation_record) { ::PersonGroupRelation.where(person_group_id: another_no_parent_person_group_record.id, child_person_group_id: existing_group_id_value) }
      let(:top_person_group_of_existing_group_record) { ::TopPersonGroup.where(person_group_id: existing_group_id_value) }
      let(:user_accessible_person_group_of_existing_group_record) { ::UserAccessibleTopPersonGroup.where(top_person_group_id: existing_group_id_value) }
      it "updated as under another group" do
        expect(old_group_relation_record.present?).to be_truthy
        expect(new_group_relation_record.present?).to be_truthy
        
        expect(top_person_group_of_existing_group_record.blank?).to be_truthy
        expect(user_accessible_person_group_of_existing_group_record.blank?).to be_truthy
      end
    end
    
    context "when update group relation under some group -> top," do
      include_context "set up group relation record for test child group"
      
      let(:group) do
        group = ::Domain::Person::Group::Repository.find_by_id_param(existing_group_record.id_param)
        group.parent_group_id = nil
        group
      end

      before do
        described_class.update(group)
      end

      it_behaves_like "group information should be updated as under some group -> top"
    end
    
    context "when update group relation under some group -> under same group(no change)," do
      include_context "set up group relation record for test child group"
      let(:group){::Domain::Person::Group::Repository.find_by_id_param(existing_group_record.id_param)}

      before do
        described_class.update(group)
      end

      it_behaves_like "group relation information should not be updated"
    end
    
    context "when update group relation under some group -> under some other group," do
      include_context "set up group relation record for test child group"
      
      let(:group) do
        group = ::Domain::Person::Group::Repository.find_by_id_param(existing_group_record.id_param)
        group.parent_group_id = ::Domain::Person::Group::Repository.build_id_from_id_param(another_no_parent_person_group_record.id_param)
        group
      end

      before do
        described_class.update(group)
      end

      it_behaves_like "group information should be updated as under different group"
    end
  end
end