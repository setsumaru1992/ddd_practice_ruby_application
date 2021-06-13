# frozen_string_literal: true

require "rails_helper"

class OneFieldValue < ::Domain::Base::ValueObject
  FIELDS = %I(age)
  attr_reader *FIELDS
  attr_updater *FIELDS
end

class OneMoreFieldValue < ::Domain::Base::ValueObject
  FIELDS = %I(sei mei)
  attr_reader *FIELDS
  attr_updater *FIELDS
end

class EntityWithFields < ::Domain::Base::Entity
  FIELDS = %I(age name)
  attr_reader *FIELDS
  attr_updater *FIELDS
end

RSpec.describe ::Domain::Base::Entity do
  describe "#update_field" do
    let(:entity) { EntityWithFields.new(OneFieldValue.new(10), OneMoreFieldValue.new("山田", "太郎")) }
    let!(:age_object_id) { entity.age.object_id }
    let!(:name_object_id) { entity.name.object_id }

    context "when update value object filed which has 1 field" do
      let(:updated_age){ 20 }

      context "," do
        before do
          entity.update_age(updated_age)
        end
  
        it "updating succeeds" do
          expect(entity.age.age).to eq updated_age
          expect(entity.age.object_id).not_to eq age_object_id
        end
      end
      
      context "with hash arg," do
        before do
          entity.update_age({age: updated_age})
        end
  
        it "updating succeeds" do
          expect(entity.age.age).to eq updated_age
        end
      end
    end
    
    context "when update value object filed which has 1 more field" do
      let(:updated_sei){ "奥山田" }
      let(:updated_mei){ "権蔵" }

      context "," do
        before do
          entity.update_name({sei: updated_sei, mei: updated_mei})
        end

        it "updating succeeds" do
          expect(entity.name.sei).to eq updated_sei
          expect(entity.name.mei).to eq updated_mei
          
          expect(entity.name.object_id).not_to eq name_object_id
        end
      end

      context "without hash arg," do
        it "updating fails" do
          expect{entity.update_name(updated_sei, updated_mei)}.to raise_error(StandardError)
        end
      end

      context "without hash arg 2," do
        it "updating fails" do
          expect{entity.update_name(updated_sei)}.to raise_error(StandardError)
        end
      end
    end
  end

  describe "changed_fields" do
    context "when one field is changed," do
      let(:entity) { EntityWithFields.new(OneFieldValue.new(10), OneMoreFieldValue.new("山田", "太郎")) }
      before do
        entity.update_age(20)
      end

      it "return only changed field" do
        expect(entity.changed_fields.keys).to eq [:age]
      end
    end
  end
  
  # TODO: nil_object関連のテスト作成。empty_buildでフィールドがnilオブジェクトで作られるなってるかなど
end