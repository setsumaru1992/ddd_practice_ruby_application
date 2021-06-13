# frozen_string_literal: true

require "rails_helper"
require_relative "../repository/repository_update_shared_examples"

RSpec.describe ::Domain::Person::Command::UpdateCommand do
  describe ".calls" do
    context "when update person essential -> essential(for skip not essential update), " do
      include_context "set up person with essential fields record for update"

      let(:disp_name) { existing_person_record.name.disp_name }

      before do
        described_class.call(
          id_param: existing_person_record.id_param,
          disp_name: disp_name
        )
      end

      include_examples "person information should not be updated",
        should_exist_name_record: true,
        should_exist_sex_record: false,
        should_exist_birthdate_record: false,
        should_exist_person_group_belonging_record: false
    end
    context "when update person full -> full, (for executing not essential update)" do
      include_context "set up person with full fields record for update"
      
      let(:should_exist_name_record) { true }
      let(:disp_name) { "なおき(修正後)" }
      let(:last_name) { "半沢(修正後)" }
      let(:first_name) { "直樹(修正後)" }
      let(:middle_name) { "ビクトリア(修正後)" }
      let(:kana) { "ハンザワナオキ(修正後)" }
      
      let(:should_exist_sex_record) { true }
      let(:birth_sex_code) { ::Domain::Person::Sex::SEX_CODES[:WOMAN] }
      let(:desired_sex_code) { ::Domain::Person::Sex::SEX_CODES[:MAN] }
      
      let(:should_exist_birthdate_record) { true }
      let(:birth_year) { 2000 }
      let(:birth_month) { 1 }
      let(:birth_date) { 1 }
      
      let(:should_exist_person_group_belonging_record) { true }
      let(:belonging_person_group_id_param) { person_group_record_for_update.id_param }

      before do
        described_class.call(
          id_param: existing_person_record.id_param,
          disp_name: disp_name,
          last_name: last_name,
          first_name: first_name,
          middle_name: middle_name,
          kana: kana,
          birth_sex_code: birth_sex_code,
          desired_sex_code: desired_sex_code,
          birth_year: birth_year,
          birth_month: birth_month,
          birth_date: birth_date,
          belonging_person_group_id_param: belonging_person_group_id_param,
        )
      end
      
      include_examples "person information should be updated"
    end
  end
end