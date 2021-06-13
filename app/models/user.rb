class User < ApplicationRecord
  has_one :user_person_mapping
   # 命名の制約の事情でテーブル名しかつけられずイケてないので、外から呼び出すときには適切な名前のメソッドを経由する
  has_one :person, through: :user_person_mapping
  private :person

  has_many :user_person_relations
  has_many :people, through: :user_person_relations

  def my_person
    person
  end
end
