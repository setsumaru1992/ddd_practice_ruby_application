# frozen_string_literal: true

require "rails_helper"
require_relative "./repository_update_shared_examples"

RSpec.describe ::Domain::Person::Repository do
  describe ".update" do
    # アブストラクト
    # - 必須
    #   - 最低限のパラメータ(create時最小限→最小限)
    #   - 最大限のパラメータ(create時最小限→最大限)
    # - オプショナル
    #   - 更新が成功するか
    #     - 最大限→最大限
    #     - 最大限→必須以外nil

    context "when update person essential -> essential, " do
      include_context "set up person with essential fields record for update"
      let(:person) do
        person = ::Domain::Person::Repository.find_by_id_param(existing_person_record.id_param)
        person
      end

      before do
        described_class.update(person)
      end
      
      include_examples "person information should not be updated",
        should_exist_name_record: true,
        should_exist_sex_record: false,
        should_exist_birthdate_record: false,
        should_exist_person_group_belonging_record: false
    end
    
    context "when update person essential -> full, " do
      include_context "set up person with essential fields record for update"

      let(:should_exist_name_record) { true }
      let(:disp_name) { "なおき" }
      let(:last_name) { "半沢" }
      let(:first_name) { "直樹" }
      let(:middle_name) { "ビクトリア" }
      let(:kana) { "ハンザワナオキ" }
      
      let(:should_exist_sex_record) { true }
      let(:birth_sex_code) { ::Domain::Person::Sex::SEX_CODES[:MAN] }
      let(:desired_sex_code) { ::Domain::Person::Sex::SEX_CODES[:WOMAN] }
      
      let(:should_exist_birthdate_record) { true }
      let(:birth_year) { 1970 }
      let(:birth_month) { 12 }
      let(:birth_date) { 8 }

      let(:person) do
        person = ::Domain::Person::Repository.find_by_id_param(existing_person_record.id_param)
        person.update_name(::Domain::Person::Name.new(disp_name, last_name, first_name, middle_name, kana))
        person.update_sex(::Domain::Person::Sex.new(birth_sex_code, desired_sex_code))
        person.update_birthdate(::Domain::Person::Birthdate.new(birth_year, birth_month, birth_date))
        person.update_person_group_id(::Domain::Person::Group::Repository.build_id_from_id_param(person_group_record_for_update.id_param))
        person
      end
      
      let(:should_exist_person_group_belonging_record) { true }

      before do
        described_class.update(person)
      end
      
      include_examples "person information should be updated"
    end
    
    context "when update person full -> full, " do
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

      let(:person) do
        person = ::Domain::Person::Repository.find_by_id_param(existing_person_record.id_param)
        person.update_name(::Domain::Person::Name.new(disp_name, last_name, first_name, middle_name, kana))
        person.update_sex(::Domain::Person::Sex.new(birth_sex_code, desired_sex_code))
        person.update_birthdate(::Domain::Person::Birthdate.new(birth_year, birth_month, birth_date))
        person.update_person_group_id(::Domain::Person::Group::Repository.build_id_from_id_param(person_group_record_for_update.id_param))
        person
      end

      before do
        described_class.update(person)
      end
      
      include_examples "person information should be updated"
    end
    
    context "when update person full -> essential(not essentials are nil), " do
      include_context "set up person with full fields record for update"
      
      let(:should_exist_name_record) { true }
      let(:disp_name) { "なおき" }
      let(:last_name) { nil }
      let(:first_name) { nil }
      let(:middle_name) { nil }
      let(:kana) { nil }
      
      let(:should_exist_sex_record) { false }
      let(:should_exist_birthdate_record) { false }
      let(:should_exist_person_group_belonging_record) { false }

      let(:person) do
        person = ::Domain::Person::Repository.find_by_id_param(existing_person_record.id_param)
        person.update_name(::Domain::Person::Name.new(disp_name, last_name, first_name, middle_name, kana))
        person.update_sex(nil)
        person.update_birthdate(nil)
        person.update_person_group_id(nil)
        person
      end

      before do
        described_class.update(person)
      end
      
      include_examples "person information should be updated"
    end
  end
end