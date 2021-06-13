FactoryBot.define do
  factory :person do
    id_param { "personaaaaaaaaaaaa" }
  end
  factory :person_with_birthdate, class: Person do
    id_param { "person_with_birthdateaaaaaaaaaaaa" }
    person_birthdate { association :person_birthdate, strategy: :build }
  end

  factory :person_with_essential_fields, class: Person do
    id_param { "person_with_essential_fieldsaaaaaaaaaaaa" }
    person_name { association :person_name_with_essential_fields, strategy: :build }
  end

  factory :person_with_full_fields, class: Person do
    id_param { "person_with_full_fieldsaaaaaaaaaaaa" }
    person_name { association :person_name_with_full_fields, strategy: :build }
    person_sex { association :person_sex, strategy: :build }
    person_birthdate { association :person_birthdate_for_person_test, strategy: :build }
  end
end