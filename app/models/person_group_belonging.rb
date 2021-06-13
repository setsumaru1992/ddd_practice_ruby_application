class PersonGroupBelonging < ApplicationRecord
  self.primary_keys = :person_id, :person_group_id
  belongs_to :person
  belongs_to :person_group
end
