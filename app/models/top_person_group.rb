class TopPersonGroup < ApplicationRecord
  self.primary_key = :person_group_id
  belongs_to :person_group
end
