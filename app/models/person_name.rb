class PersonName < ApplicationRecord
  self.primary_key = :person_id
  belongs_to :person
  
  validates :disp_name, presence: true
end
