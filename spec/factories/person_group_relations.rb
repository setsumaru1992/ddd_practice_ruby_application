FactoryBot.define do
  factory :person_group_relation do
    person_group { PersonGroup.find_by(id_param: "aaaaaaaaaaaa") }
    child_person_group { PersonGroup.find_by(id_param: "child_person_groupaaaaaaaaaaaa") }
  end
end