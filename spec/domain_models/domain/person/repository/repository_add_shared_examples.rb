# frozen_string_literal: true

RSpec.shared_context "set up person record for add" do
  let!(:user_record) { FactoryBot.create(:user) }
  let!(:group_record) { FactoryBot.create(:person_group) }
end

RSpec.shared_examples "person essential information should be created" do |example_statement|
  # 使用箇所で必要な記述
  # - let変数定義
  #     - new_person_id_value: integer
  #     - disp_name: string

  # テストで共用する変数定義
  let(:new_person_record) { ::Person.where(id: new_person_id_value).first }
  let(:new_person_name_record) { ::PersonName.where(person_id: new_person_id_value).first }

  it example_statement.presence || "creating succeed" do
    expect(new_person_record.present?).to be_truthy
    
    expect(new_person_name_record.present?).to be_truthy
    expect(new_person_name_record.disp_name).to eq disp_name
  end
end

RSpec.shared_examples "person optional information should be created" do |example_statement|
  # 使用箇所で必要な記述
  # - let変数定義
  #     - new_person_id_value: integer
  #     - last_name: string
  #     - first_name: string
  #     - middle_name: string
  #     - kana: string
  #     - birth_sex_code: integer
  #     - desired_sex_code: integer
  #     - birth_year: integer
  #     - birth_month: integer
  #     - birth_date: integer

  # テストで共用する変数定義
  let(:new_person_record) { ::Person.where(id: new_person_id_value).first }
  let(:new_person_name_record) { ::PersonName.where(person_id: new_person_id_value).first }
  let(:new_person_sex_record) { ::PersonSex.where(person_id: new_person_id_value).first }
  let(:new_person_birthdate_record) { ::PersonBirthdate.where(person_id: new_person_id_value).first }

  it example_statement.presence || "creating succeed" do
    expect(new_person_name_record.present?).to be_truthy
    expect(new_person_name_record.last_name).to eq last_name
    expect(new_person_name_record.first_name).to eq first_name
    expect(new_person_name_record.middle_name).to eq middle_name
    expect(new_person_name_record.kana).to eq kana
        
    expect(new_person_sex_record.present?).to be_truthy
    expect(new_person_sex_record.birth_sex_code).to eq birth_sex_code
    expect(new_person_sex_record.desired_sex_code).to eq desired_sex_code
    
    expect(new_person_birthdate_record.present?).to be_truthy
    expect(new_person_birthdate_record.year).to eq birth_year
    expect(new_person_birthdate_record.month).to eq birth_month
    expect(new_person_birthdate_record.date).to eq birth_date
  end
end

RSpec.shared_examples "person relation information should be created" do |exist_person_group_belonging: false, exist_user_person_relation: true, exist_user_person_mapping: false|
  # 使用箇所で必要な記述
  # - let変数定義
  #     - new_person_id_value: integer
  # - includeされるコンテキスト(ラッピングされたもの可)
  #     - set up person record for add
      

  # テストで共用する変数定義
  let(:new_person_group_belonging_record) { ::PersonGroupBelonging.where(person_id: new_person_id_value).first }
  let(:new_user_person_relation_record) { ::UserPersonRelation.where(person_id: new_person_id_value).first }
  let(:new_user_person_mapping_record) { ::UserPersonMapping.where(person_id: new_person_id_value).first }

  it "creating succeed" do
    if exist_person_group_belonging
      expect(new_person_group_belonging_record.present?).to be_truthy
      expect(new_person_group_belonging_record.person_group_id).to eq group_record.id
    else
      expect(new_person_group_belonging_record.blank?).to be_truthy
    end
    
    if exist_user_person_relation
      expect(new_user_person_relation_record.present?).to be_truthy
      expect(new_user_person_relation_record.user_id).to eq user_record.id
    else
      expect(new_user_person_relation_record.blank?).to be_truthy
    end
    
    if exist_user_person_mapping
      expect(new_user_person_mapping_record.present?).to be_truthy
      expect(new_user_person_mapping_record.user_id).to eq user_record.id
    else
      expect(new_user_person_mapping_record.blank?).to be_truthy
    end
  end
end