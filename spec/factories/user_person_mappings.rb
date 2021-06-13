FactoryBot.define do
  factory :user_person_mapping ,class: UserPersonMapping do
    person { Person.find_by(id_param: "personaaaaaaaaaaaa") }
    user { User.find_by(id_param: "aaaaaaaaaaaa") }
  end

  factory :user_person_mapping_for_essential_field_person ,class: UserPersonMapping do
    person { Person.find_by(id_param: "person_with_essential_fieldsaaaaaaaaaaaa") }
    user { User.find_by(id_param: "aaaaaaaaaaaa") }
  end
end