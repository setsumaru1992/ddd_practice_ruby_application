# frozen_string_literal: true

require "rails_helper"
require_relative "../repository/repository_add_shared_examples"

RSpec.describe ::Domain::Person::Command::CreateCommand do
  describe ".call" do
    include_context "set up person record for add"

    context "when add person with full fields" do
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

      let!(:new_person) do
        described_class.call(
          disp_name: disp_name,
          first_name: first_name,
          last_name: last_name,
          middle_name: middle_name,
          kana: kana,
          birth_sex_code: birth_sex_code,
          desired_sex_code: desired_sex_code,
          birth_year: birth_year,
          birth_month: birth_month,
          birth_date: birth_date,
          belonging_person_group_id_param: group_record.id_param,
          accessible_user_id_param: user_record.id_param
        )
      end
      let!(:new_person_id) { new_person.id }
      let(:new_person_id_value) { new_person_id.value }

      it_behaves_like "person essential information should be created"
      it_behaves_like "person optional information should be created"
      it_behaves_like "person relation information should be created", 
        exist_person_group_belonging: true, 
        exist_user_person_relation: true, 
        exist_user_person_mapping: false
    end
  end
end