class CreateUserAccessibleTopPersonGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :user_accessible_top_person_groups, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :top_person_group_id, null: false

      t.timestamps
    end
    
    add_foreign_key :user_accessible_top_person_groups, :top_person_groups, column: :top_person_group_id, primary_key: :person_group_id
    add_index :user_accessible_top_person_groups, [:user_id, :top_person_group_id], name:'index_user_accessible_top_person_groups_on_user_and_group', unique: true
  end
end
