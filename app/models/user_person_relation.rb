class UserPersonRelation < ApplicationRecord
  self.primary_keys = :user_id, :person_id
  belongs_to :user
  belongs_to :person
end
