# frozen_string_literal: true

RSpec.shared_context "set up group relation record for remove" do
  let!(:parent_group_record) { FactoryBot.create(:person_group) }
  let!(:child_group_record) { FactoryBot.create(:child_person_group) }
  let!(:group_relation_record) { FactoryBot.create(:person_group_relation) }
  let!(:top_person_group) { FactoryBot.create(:top_person_group) }
  let!(:user_record) { FactoryBot.create(:user) }
  let!(:user_accessible_top_person_group) { FactoryBot.create(:user_accessible_top_person_group) }
end

RSpec.shared_context "set up group relation record for test top group for remove" do
  include_context "set up group relation record for remove"
  let(:existing_group_record) { parent_group_record }
end

RSpec.shared_context "set up group relation record for test child group for remove" do
  include_context "set up group relation record for remove"
  let(:existing_group_record) { child_group_record }
end

RSpec.shared_context "set up group relation record for test child group with person for remove" do
  include_context "set up group relation record for test child group for remove"
  let!(:person_with_essential_record) { FactoryBot.create(:person_with_essential_fields) }
  let!(:person_group_belonging_for_person_with_full_fields) { FactoryBot.create(:person_group_belonging_for_person_with_essential_fields_and_no_child_group) }
end

RSpec.shared_examples "group relation information should be removed complately" do |example_statement|
  # 使用箇所で定義する必要があるもの
  # "set up group relation record for remove"コンテキスト(直接でもラッピングしたものでも)のinclude

  let!(:group_relation_record_as_child_before) { ::PersonGroupRelation.where(child_person_group_id: existing_group_id_value) }

  let(:existing_group_id_value) { existing_group_record.id }
  let(:group_relation_record_as_parent) { ::PersonGroupRelation.where(person_group_id: existing_group_id_value) }
  let(:group_relation_record_as_child) { ::PersonGroupRelation.where(child_person_group_id: existing_group_id_value) }
  let(:top_person_group_of_existing_group_record) { ::TopPersonGroup.where(person_group_id: existing_group_id_value) }
  let(:user_accessible_person_group_of_existing_group_record) { ::UserAccessibleTopPersonGroup.where(top_person_group_id: existing_group_id_value) }

  let(:parent_group_relation_record) do
    if group_relation_record_as_child_before.present?
      ::PersonGroupRelation.where(person_group_id: group_relation_record_as_child_before.person_group_id)
    else
      nil
    end
  end

  it "removed succeeded" do
    expect(group_relation_record_as_parent.blank?).to be_truthy
    expect(group_relation_record_as_child.blank?).to be_truthy
    
    expect(top_person_group_of_existing_group_record.blank?).to be_truthy
    expect(user_accessible_person_group_of_existing_group_record.blank?).to be_truthy
  end
end