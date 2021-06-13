# frozen_string_literal: true

require "rails_helper"
require_relative "./repository_add_shared_examples"

RSpec.describe ::Domain::Person::Repository do
  describe ".add" do
    include_context "set up person record for add"
    let(:person) { ::Domain::Person::Factory.build(param) }

    context "when add person with essential fields, " do
      let(:disp_name) { "なおき" }
      let(:param) do
        param = ::Domain::Person::PersonParameter.new
        param.disp_name = disp_name
        param.accessible_user_id_param = user_record.id_param
        param
      end

      let!(:new_person_id) { described_class.add(person) }
      let(:new_person_id_value) { new_person_id.value }

      it_behaves_like "person essential information should be created"
      it_behaves_like "person relation information should be created", 
        exist_person_group_belonging: false,
        exist_user_person_mapping: false
    end

    context "when add person with full fields, " do
      let(:disp_name) { "なおき" }
      let(:last_name) { "半沢" }
      let(:first_name) { "直樹" }
      let(:middle_name) { "ビクトリア" }
      let(:kana) { "ハンザワナオキ" }
      
      let(:birth_sex_code) { ::Domain::Person::Sex::SEX_CODES[:MAN] }
      let(:desired_sex_code) { ::Domain::Person::Sex::SEX_CODES[:WOMAN] }
      
      let(:birth_year) { 1970 }
      let(:birth_month) { 12 }
      let(:birth_date) { 8 }

      let(:param) do
        param = ::Domain::Person::PersonParameter.new
        param.disp_name = disp_name
        param.first_name = first_name
        param.last_name = last_name
        param.middle_name = middle_name
        param.kana = kana
        param.birth_sex_code = birth_sex_code
        param.desired_sex_code = desired_sex_code
        param.birth_year = birth_year
        param.birth_month = birth_month
        param.birth_date = birth_date
        param.belonging_person_group_id_param = group_record.id_param
        param.accessible_user_id_param = user_record.id_param
        param
      end

      let!(:new_person_id) { described_class.add(person) }
      let(:new_person_id_value) { new_person_id.value }

      it_behaves_like "person essential information should be created"
      it_behaves_like "person optional information should be created"
      it_behaves_like "person relation information should be created", 
        exist_person_group_belonging: true,
        exist_user_person_mapping: false
    end
  end

  describe ".add" do
    include_context "set up person record for add"
    let(:person) { ::Domain::Person::Factory.build(param) }

    context "when add self, " do
      let(:disp_name) { "なおき" }

      let(:param) do
        param = ::Domain::Person::PersonParameter.new
        param.disp_name = disp_name
        param.accessible_user_id_param = user_record.id_param
        param
      end

      let!(:new_person_id) { described_class.add_user_self_person(person) }
      let(:new_person_id_value) { new_person_id.value }

      it_behaves_like "person essential information should be created"
      it_behaves_like "person relation information should be created", 
        exist_person_group_belonging: false,
        exist_user_person_mapping: true
    end
  end
end