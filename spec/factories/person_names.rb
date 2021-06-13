FactoryBot.define do
  factory :person_name_with_essential_fields, class: PersonName do
    disp_name { "なおき" }
  end
  
  factory :person_name_with_full_fields, class: PersonName do
    disp_name { "なおき" }
    last_name { "半沢" }
    first_name { "直樹" }
    middle_name { "ビクトリア" }
    kana { "ハンザワナオキ" }
  end
end