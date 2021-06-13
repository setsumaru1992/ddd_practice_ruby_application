FactoryBot.define do
  # なにかとともに使うときはトップとして扱う。
  factory :person_group do
    id_param { "aaaaaaaaaaaa" }
    name {"東京中央銀行"}
  end
  
  factory :child_person_group, class: PersonGroup do
    id_param { "child_person_groupaaaaaaaaaaaa" }
    name { "融資課" }
  end
  
  factory :another_no_parent_person_group, class: PersonGroup do
    id_param { "another_top" }
    name { "伊勢志摩ホテル" }
  end
end