class PersonSex < ApplicationRecord
  self.primary_key = :person_id
  belongs_to :person
end
