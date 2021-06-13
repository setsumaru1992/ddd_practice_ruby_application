class Person < ApplicationRecord
  has_one :user_person_mapping
  has_one :user, through: :user_person_mapping
  has_many :user_person_relations

  has_one :name, class_name: "PersonName"
  has_one :birthdate, class_name: "PersonBirthdate"
  has_one :sex, class_name: "PersonSex"
  
  has_one :person_group_belonging
  has_one :person_group, through: :person_group_belonging

  scope :user_accessible_persons, ->(user_id){
    joins(:user_person_relations)
    .where(user_person_relations: {user_id: user_id})
  }
end
