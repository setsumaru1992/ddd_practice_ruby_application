FactoryBot.define do
  factory :user_accessible_top_person_group do
    user { User.find_by(id_param: "aaaaaaaaaaaa") }
    top_person_group { PersonGroup.find_by(id_param: "aaaaaaaaaaaa").top_person_group }
  end
  
  factory :another_user_accessible_top_person_group, class: UserAccessibleTopPersonGroup do
    user { User.find_by(id_param: "aaaaaaaaaaaa") }
    top_person_group { PersonGroup.find_by(id_param: "another_top").top_person_group }
  end
end