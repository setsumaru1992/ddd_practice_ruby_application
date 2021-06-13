class PersonGroup < ApplicationRecord
  # 直近の親以外の階層取得に関わるfinder系処理はPersonGroupHierarchyに移譲
  has_many :person_group_relations
  has_one :person_group_relation_on_child_side, class_name: "PersonGroupRelation", foreign_key: "child_person_group_id"
  has_one :top_person_group

  has_many :children, through: :person_group_relations
  has_one :parent, through: :person_group_relation_on_child_side

  has_many :person_group_belonging
  has_many :person, through: :person_group_belonging
end
