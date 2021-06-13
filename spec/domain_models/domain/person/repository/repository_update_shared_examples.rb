# frozen_string_literal: true

RSpec.shared_context "set up person record for update" do
  let!(:user_record) { FactoryBot.create(:user) }
  let!(:person_with_essential_record) { FactoryBot.create(:person_with_essential_fields) }
  let!(:person_relation_record_with_essential_fields_person) { FactoryBot.create(:user_person_relation_for_essential_field_person) }
  let!(:person_with_full_record) { FactoryBot.create(:person_with_full_fields) }
  let!(:person_relation_record_with_full_fields_person) { FactoryBot.create(:user_person_relation_for_full_field_field_person) }

  let!(:person_group_for_person_with_full_fields) { FactoryBot.create(:person_group) }
  let!(:person_group_record_for_update) { FactoryBot.create(:child_person_group) }
  let!(:person_group_belonging_for_person_with_full_fields) { FactoryBot.create(:person_group_belonging_for_person_with_full_fields) }
end

RSpec.shared_context "set up person with essential fields record for update" do
  include_context "set up person record for update"
  let(:existing_person_record) { person_with_essential_record }
end

RSpec.shared_context "set up person with full fields record for update" do
  include_context "set up person record for update"
  let(:existing_person_record) { person_with_full_record }
end

RSpec.shared_examples "person information should not be updated" do |should_exist_name_record: true, should_exist_sex_record: true, should_exist_birthdate_record: true, should_exist_person_group_belonging_record: true |
  # 使用箇所で定義する必要があるもの
  # "set up group relation record"コンテキスト(直接でもラッピングしたものでも)のinclude

  let(:person_id_value_before_update) { existing_person_record.id }
  let!(:person_name_record_before_update) { ::PersonName.where(person_id: person_id_value_before_update).first }
  let!(:person_sex_record_before_update) { ::PersonSex.where(person_id: person_id_value_before_update).first }
  let!(:person_birthdate_record_before_update) { ::PersonBirthdate.where(person_id: person_id_value_before_update).first }
  let!(:person_group_belonging_record_before_update) { ::PersonGroupBelonging.where(person_id: person_id_value_before_update).first }

  let(:should_exist_name_record) { should_exist_name_record }
  let(:disp_name) { person_name_record_before_update.disp_name }
  let(:last_name) { person_name_record_before_update.last_name }
  let(:first_name) { person_name_record_before_update.first_name }
  let(:middle_name) { person_name_record_before_update.middle_name }
  let(:kana) { person_name_record_before_update.kana }

  let(:should_exist_sex_record) { should_exist_sex_record }
  let(:birth_sex_code) { person_sex_record_before_update.birth_sex_code }
  let(:desired_sex_code) { person_sex_record_before_update.desired_sex_code }

  let(:should_exist_birthdate_record) { should_exist_birthdate_record }
  let(:birth_year) { person_birthdate_record_before_update.birth_year }
  let(:birth_month) { person_birthdate_record_before_update.birth_month }
  let(:birth_date) { person_birthdate_record_before_update.birth_date }

  let(:should_exist_person_group_belonging_record) { should_exist_person_group_belonging_record }
      
  include_examples "person information should be updated"
end

RSpec.shared_examples "person information should be updated" do |example_statement|
  # 使用箇所で定義する必要があるもの
  # - "set up person record"コンテキスト(直接でもラッピングしたものでも)のinclude
  # - let変数定義
  #     - name関連
  #         - should_exist_name_record: boolean
  #             - レコードが存在するかどうか
  #                 - 存在する場合フィールドチェック
  #                 - 存在しない場合非存在チェック
  #         - disp_nameなど
  #     - sex関連
  #     - birthdate関連
  #     - person_group関連
  
  # テストで共用する変数定義
  let(:updated_person_id_value) { existing_person_record.id }
  let(:updated_person_record) { ::Person.where(id: updated_person_id_value).first }
  let(:updated_person_name_record) { ::PersonName.where(person_id: updated_person_id_value).first }
  let(:updated_person_sex_record) { ::PersonSex.where(person_id: updated_person_id_value).first }
  let(:updated_person_birthdate_record) { ::PersonBirthdate.where(person_id: updated_person_id_value).first }
  let(:updated_person_group_belonging_record) { ::PersonGroupBelonging.where(person_id: updated_person_id_value).first }

  it example_statement.presence || "updating succeed" do
    expect(updated_person_record.present?).to be_truthy

    if should_exist_name_record
      expect(updated_person_name_record.present?).to be_truthy
      expect(updated_person_name_record.disp_name).to eq disp_name
      expect(updated_person_name_record.last_name).to eq last_name
      expect(updated_person_name_record.first_name).to eq first_name
      expect(updated_person_name_record.middle_name).to eq middle_name
      expect(updated_person_name_record.kana).to eq kana
    else
      expect(updated_person_name_record.blank?).to be_truthy
    end

    if should_exist_sex_record
      expect(updated_person_sex_record.present?).to be_truthy
      expect(updated_person_sex_record.birth_sex_code).to eq birth_sex_code
      expect(updated_person_sex_record.desired_sex_code).to eq desired_sex_code
    else
      expect(updated_person_sex_record.blank?).to be_truthy
    end

    if should_exist_birthdate_record
      expect(updated_person_birthdate_record.present?).to be_truthy
      expect(updated_person_birthdate_record.year).to eq birth_year
      expect(updated_person_birthdate_record.month).to eq birth_month
      expect(updated_person_birthdate_record.date).to eq birth_date
    else
      expect(updated_person_birthdate_record.blank?).to be_truthy
    end

    if should_exist_person_group_belonging_record
      expect(updated_person_group_belonging_record.present?).to be_truthy
      expect(updated_person_group_belonging_record.person_group_id).to eq person_group_record_for_update.id
    else
      expect(updated_person_group_belonging_record.blank?).to be_truthy
    end
  end
end