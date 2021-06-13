FactoryBot.define do
  factory :person_sex, class: PersonSex do
    birth_sex_code { ::Domain::Person::Sex::SEX_CODES[:MAN] }
    desired_sex_code { ::Domain::Person::Sex::SEX_CODES[:WOMAN] }
  end
end