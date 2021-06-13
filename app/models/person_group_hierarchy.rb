class PersonGroupHierarchy < ApplicationRecord
  scope :filter_user_accessible_person_group, ->(user_id){
    where(user_id: user_id)
  }
  scope :contain_group, ->(group_id){
    where(top_group_id: group_id)
      .or(self.where(middle_group_id: group_id))
      .or(self.where(bottom_group_id: group_id))
  }
end
