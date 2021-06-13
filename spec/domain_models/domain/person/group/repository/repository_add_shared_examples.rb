# frozen_string_literal: true

RSpec.shared_examples "new group and its relation should be created as top group" do |example_statement|
  # 使用箇所ででlet定義する必要がある変数
  # new_group_name: string
  # new_group_id_value: int(::Domain::Person::Group::Id#valueの値)
  
  # 事前条件
  let!(:user_record) { FactoryBot.create(:user) }

  # テストで共用する変数定義
  let(:new_person_group_record) { ::PersonGroup.last }
  let(:new_top_person_group_record) { ::TopPersonGroup.last }
  let(:new_user_accessible_person_group_record) { ::UserAccessibleTopPersonGroup.last }

  it example_statement.presence || "creating records succeeds" do
    expect(new_person_group_record.id).to eq new_group_id_value
    expect(new_person_group_record.name).to eq new_group_name

    expect(new_top_person_group_record.person_group_id).to eq new_group_id_value
    
    expect(new_user_accessible_person_group_record.user_id).to eq user_record.id
    expect(new_user_accessible_person_group_record.top_person_group_id).to eq new_top_person_group_record.person_group_id

    expect(::PersonGroupRelation.where(person_group_id: new_group_id_value).blank?).to be_truthy
    expect(::PersonGroupRelation.where(child_person_group_id: new_group_id_value).blank?).to be_truthy
  end
end

RSpec.shared_examples "new group and its relation should be created under some group" do |example_statement|
  # 使用箇所ででlet定義する必要がある変数
  # new_group_name: string
  # new_group_id_value: int(::Domain::Person::Group::Id#valueの値)
  
  # 事前条件
  let!(:user_record) { FactoryBot.create(:user) }
  let!(:parent_group_record) { FactoryBot.create(:person_group) }

  # テストで共用する変数定義
  let(:new_group_record) { ::PersonGroup.last }
  let(:new_group_relation_record) { ::PersonGroupRelation.last }
  let(:parent_group_id_value) { parent_group_record.id }

  it example_statement.presence || "creating records succeeds" do
    expect(new_group_record.id).to eq new_group_id_value
    expect(new_group_record.name).to eq new_group_name

    expect(new_group_relation_record.person_group_id).to eq parent_group_id_value
    expect(new_group_relation_record.child_person_group_id).to eq new_group_id_value

    expect(::TopPersonGroup.where(person_group_id: new_group_id_value).blank?).to be_truthy
    expect(::UserAccessibleTopPersonGroup.where(top_person_group_id: new_group_id_value).blank?).to be_truthy
  end
end