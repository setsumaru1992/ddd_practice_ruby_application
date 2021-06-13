class CreatePersonGroupRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :person_group_relations, id: false do |t|
      t.references :person_group, null: false, foreign_key: { to_table: :person_groups }
      t.references :child_person_group, null: false, foreign_key: { to_table: :person_groups }

      t.timestamps
    end
    add_index :person_group_relations, [:person_group_id, :child_person_group_id], name: 'index_person_group_relations_on_parent_and_child', unique: true
  end
end
