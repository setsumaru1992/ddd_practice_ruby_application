class UserAccessibleTopPersonGroup < ApplicationRecord
  self.primary_keys = :user_id, :top_person_group_id
  belongs_to :user
  belongs_to :top_person_group
end
