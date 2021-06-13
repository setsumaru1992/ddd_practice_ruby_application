FactoryBot.define do
  factory :person_birthdate do
    year { 1992 }
    month { 11 }
    date { 4 }
  end

  factory :person_birthdate_for_person_test, class: PersonBirthdate do
    year { 1970 }
    month { 12 }
    date { 8 }
  end
end