class CreateUserPersonMappings < ActiveRecord::Migration[6.0]
  def change
    create_table :user_person_mappings, id: false do |t|
      t.references :user, index: {:unique=>true}, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
