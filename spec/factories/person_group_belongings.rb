FactoryBot.define do
  factory :person_group_belonging_for_person_with_full_fields ,class: PersonGroupBelonging do
    person { Person.find_by(id_param: "person_with_full_fieldsaaaaaaaaaaaa") }
    person_group { PersonGroup.find_by(id_param: "aaaaaaaaaaaa") }
  end
  
  factory :person_group_belonging_for_person_with_essential_fields_and_no_child_group ,class: PersonGroupBelonging do
    person { Person.find_by(id_param: "person_with_essential_fieldsaaaaaaaaaaaa") }
    person_group { PersonGroup.find_by(id_param: "child_person_groupaaaaaaaaaaaa") }
  end
end