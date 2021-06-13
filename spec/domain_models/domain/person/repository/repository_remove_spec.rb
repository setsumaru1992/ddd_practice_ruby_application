# frozen_string_literal: true

require "rails_helper"
require_relative "./repository_remove_shared_examples"

RSpec.describe ::Domain::Person::Repository do
  describe ".remove" do
    context "when remove person with full field, " do
      include_context "set up person with full fields record for remove"
      let(:person) { ::Domain::Person::Repository.find_by_id_param(existing_person_record.id_param) }

      before do
        described_class.remove(person)
      end

      it_behaves_like "person should be removed completely"
    end
    
    context "when remove person with essential field, " do
      include_context "set up person with essential fields record for remove"
      let(:person) { ::Domain::Person::Repository.find_by_id_param(existing_person_record.id_param) }

      before do
        described_class.remove(person)
      end

      it_behaves_like "person should be removed completely"
    end
  end
end