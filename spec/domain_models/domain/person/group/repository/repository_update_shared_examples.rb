# frozen_string_literal: true

RSpec.shared_context "set up group relation record" do
  let!(:parent_group_record) { FactoryBot.create(:person_group) }
  let!(:child_group_record) { FactoryBot.create(:child_person_group) }
  let!(:group_relation_record) { FactoryBot.create(:person_group_relation) }
  let!(:top_person_group) { FactoryBot.create(:top_person_group) }
  let!(:user_record) { FactoryBot.create(:user) }
  let!(:user_accessible_top_person_group) { FactoryBot.create(:user_accessible_top_person_group) }

  let!(:another_no_parent_person_group_record) { FactoryBot.create(:another_no_parent_person_group) }
  let!(:another_top_person_group_record) { FactoryBot.create(:another_top_person_group) }
  let!(:another_user_accessible_top_person_group_record) { FactoryBot.create(:another_user_accessible_top_person_group) }
end

RSpec.shared_context "set up group relation record for test top group" do
  include_context "set up group relation record"
  let(:existing_group_record) { parent_group_record }
end

RSpec.shared_context "set up group relation record for test child group" do
  include_context "set up group relation record"
  let(:existing_group_record) { child_group_record }
end

RSpec.shared_examples "group relation information should not be updated" do |example_statement|
  # 使用箇所で定義する必要があるもの
  # "set up group relation record"コンテキスト(直接でもラッピングしたものでも)のinclude

  it example_statement.presence || "no change exists" do
    expect(::PersonGroupRelation.find_by(group_relation_record.attributes).present?).to be_truthy
    expect(::TopPersonGroup.find_by(top_person_group.attributes).present?).to be_truthy
    expect(::UserAccessibleTopPersonGroup.find_by(user_accessible_top_person_group.attributes).present?).to be_truthy
  end
end

RSpec.shared_examples "group information should be updated except relation" do |example_statement|
  # 使用箇所で定義する必要があるもの
  # - 変数 updated_group_name: string
  # - 以下のどちらかコンテキスト(直接でもラッピングしたものでも)のinclude
  #   - "set up group relation record for test top group"
  #   - "set up group relation record for test child group"

  it example_statement.presence || "updating succeed" do
    expect(::PersonGroup.find(existing_group_record.id).name).to eq updated_group_name
  end
end

RSpec.shared_examples "group information should be updated as under different group" do |example_statement|
  # テストで共用する変数定義
  let(:existing_group_id_value) { existing_group_record.id }
  let(:old_group_relation_record) { ::PersonGroupRelation.where(person_group_id: parent_group_record.id, child_person_group_id: existing_group_id_value) }
  let(:new_group_relation_record) { ::PersonGroupRelation.where(person_group_id: another_no_parent_person_group_record.id, child_person_group_id: existing_group_id_value) }
  let(:top_person_group_of_existing_group_record) { ::TopPersonGroup.where(person_group_id: existing_group_id_value) }
  let(:user_accessible_person_group_of_existing_group_record) { ::UserAccessibleTopPersonGroup.where(top_person_group_id: existing_group_id_value) }

  it example_statement.presence || "updating succeed" do
    expect(old_group_relation_record.blank?).to be_truthy
    expect(new_group_relation_record.present?).to be_truthy
    
    expect(top_person_group_of_existing_group_record.blank?).to be_truthy
    expect(user_accessible_person_group_of_existing_group_record.blank?).to be_truthy
  end
end



RSpec.shared_examples "group information should be updated as under some group -> top" do |example_statement|
  let(:existing_group_id_value) { existing_group_record.id }
  let(:old_group_relation_record) { PersonGroupRelation.where(child_person_group_id: existing_group_id_value) }
  let(:new_top_person_group_record) { ::TopPersonGroup.find_by(person_group_id: existing_group_id_value) }
  let(:new_user_accessible_person_group_record) { ::UserAccessibleTopPersonGroup.find_by(top_person_group_id: existing_group_id_value) }
  it example_statement.presence || "updated as top group" do
    expect(old_group_relation_record.blank?).to be_truthy

    expect(new_top_person_group_record.present?).to be_truthy
    
    expect(new_user_accessible_person_group_record.user_id).to eq user_record.id
    expect(new_user_accessible_person_group_record.top_person_group_id).to eq existing_group_id_value
  end
end