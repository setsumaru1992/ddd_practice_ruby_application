class PersonGroupRelation < ApplicationRecord
  self.primary_keys = :person_group_id, :child_person_group_id
  belongs_to :person_group
  belongs_to :child_person_group, class_name: "PersonGroup"

  # 直近の親子関係を取るために以下を組んでいるが、実は↑が不要であれば削除
  belongs_to :children, class_name: "PersonGroup", foreign_key: "child_person_group_id"
  belongs_to :parent, class_name: "PersonGroup", foreign_key: "person_group_id"
end
