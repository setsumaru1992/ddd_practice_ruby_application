class CreatePersonNames < ActiveRecord::Migration[6.0]
  def change
    create_table :person_names, id: false do |t|
      t.references :person, index: {:unique=>true}, null: false, foreign_key: true
      t.string :dispname, null: false
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :kana

      t.timestamps
    end
  end
end
