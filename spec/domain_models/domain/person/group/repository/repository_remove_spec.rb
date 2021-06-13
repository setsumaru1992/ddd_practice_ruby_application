# frozen_string_literal: true

require "rails_helper"
require_relative "./repository_remove_shared_examples"

RSpec.describe ::Domain::Person::Group::Repository do
  describe ".remove" do
    context "when remove not exist group," do
    end
    
    context "when remove top group with no children," do
      include_context "set up group relation record for test top group for remove"
      let(:group) {::Domain::Person::Group::Repository.find_by_id_param(existing_group_record.id_param)}

      before do
        # テンプレートを使った上で子無し状況創出のための前処理
        group_relation_record.destroy
        
        described_class.remove(group)
      end
      
      it_behaves_like "group relation information should be removed complately"
    end
    
    context "when remove group under some group with no children," do
      include_context "set up group relation record for test child group for remove"
      let(:group) {::Domain::Person::Group::Repository.find_by_id_param(existing_group_record.id_param)}

      before do
        described_class.remove(group)
      end
      
      it_behaves_like "group relation information should be removed complately"
    end
    
    context "when remove group under some group with children," do      
      include_context "set up group relation record for test top group for remove"
      let(:group) {::Domain::Person::Group::Repository.find_by_id_param(existing_group_record.id_param)}

      before do
        described_class.remove(group)
      end
      
      it_behaves_like "group relation information should be removed complately"
    end
  end
end