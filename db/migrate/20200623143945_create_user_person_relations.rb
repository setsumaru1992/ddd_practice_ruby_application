class CreateUserPersonRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :user_person_relations, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :user_person_relations, [:user_id, :person_id], unique: true
  end
end
