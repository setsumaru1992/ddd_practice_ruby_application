class UserPersonMapping < ApplicationRecord
  self.primary_key = :person_id
  belongs_to :user
  belongs_to :person
end
