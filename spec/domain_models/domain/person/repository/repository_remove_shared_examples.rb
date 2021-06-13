# frozen_string_literal: true

RSpec.shared_context "set up person record for remove" do
  let!(:user_record) { FactoryBot.create(:user) }
  let!(:person_with_essential_record) { FactoryBot.create(:person_with_essential_fields) }
  let!(:person_relation_record_with_essential_fields_person) { FactoryBot.create(:user_person_relation_for_essential_field_person) }
  let!(:person_with_full_record) { FactoryBot.create(:person_with_full_fields) }
  let!(:person_relation_record_with_full_fields_person) { FactoryBot.create(:user_person_relation_for_full_field_field_person) }

  let!(:person_group_for_person_with_full_fields) { FactoryBot.create(:person_group) }
  let!(:person_group_belonging_for_person_with_full_fields) { FactoryBot.create(:person_group_belonging_for_person_with_full_fields) }
end

RSpec.shared_context "set up person with essential fields record for remove" do
  include_context "set up person record for remove"
  let(:existing_person_record) { person_with_essential_record }
end

RSpec.shared_context "set up person with full fields record for remove" do
  include_context "set up person record for remove"
  let(:existing_person_record) { person_with_full_record }
end

RSpec.shared_context "set up user self person for remove" do
  include_context "set up person with essential fields record for remove"
  let!(:user_person_mapping_record) { FactoryBot.create(:user_person_mapping_for_essential_field_person) }
end

RSpec.shared_examples "person should be removed completely" do |example_statement|
  # 使用箇所で定義する必要があるもの
  # "set up group relation record"コンテキスト(直接でもラッピングしたものでも)のinclude

  # テストで共用する変数定義
  let(:removed_person_id_value) { existing_person_record.id }
  let(:removed_person_record) { ::Person.where(id: removed_person_id_value) }
  let(:removed_person_name_record) { ::PersonName.where(person_id: removed_person_id_value) }
  let(:removed_person_sex_record) { ::PersonSex.where(person_id: removed_person_id_value) }
  let(:removed_person_birthdate_record) { ::PersonBirthdate.where(person_id: removed_person_id_value) }
  let(:removed_person_group_belonging_record) { ::PersonGroupBelonging.where(person_id: removed_person_id_value) }
  let(:removed_user_person_relation_record) { ::UserPersonRelation.where(person_id: removed_person_id_value) }
  let(:removed_user_person_mapping_record) { ::UserPersonMapping.where(person_id: removed_person_id_value) }

  it example_statement.presence || "removing succeed" do
    expect(removed_person_record.blank?).to be_truthy
    expect(removed_person_name_record.blank?).to be_truthy
    expect(removed_person_sex_record.blank?).to be_truthy
    expect(removed_person_birthdate_record.blank?).to be_truthy
    expect(removed_person_group_belonging_record.blank?).to be_truthy
    expect(removed_user_person_relation_record.blank?).to be_truthy
    expect(removed_user_person_mapping_record.blank?).to be_truthy
  end
end