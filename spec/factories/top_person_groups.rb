FactoryBot.define do
  factory :top_person_group do
    person_group { PersonGroup.find_by(id_param: "aaaaaaaaaaaa") }
  end
  
  factory :another_top_person_group, class: TopPersonGroup do
    person_group { PersonGroup.find_by(id_param: "another_top") }
  end
end