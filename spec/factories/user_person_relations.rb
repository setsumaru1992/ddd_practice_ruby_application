FactoryBot.define do
  factory :user_person_relation_for_person_with_birthdate ,class: UserPersonRelation do
    person { Person.find_by(id_param: "person_with_birthdateaaaaaaaaaaaa") }
    user { User.find_by(id_param: "aaaaaaaaaaaa") }
  end

  factory :user_person_relation_for_essential_field_person ,class: UserPersonRelation do
    person { Person.find_by(id_param: "person_with_essential_fieldsaaaaaaaaaaaa") }
    user { User.find_by(id_param: "aaaaaaaaaaaa") }
  end
  
  factory :user_person_relation_for_full_field_field_person ,class: UserPersonRelation do
    person { Person.find_by(id_param: "person_with_full_fieldsaaaaaaaaaaaa") }
    user { User.find_by(id_param: "aaaaaaaaaaaa") }
  end
end