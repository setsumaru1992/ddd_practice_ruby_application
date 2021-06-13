class CreatePersonSexes < ActiveRecord::Migration[6.0]
  def change
    create_table :person_sexes, id: false do |t|
      t.references :person, index: {:unique=>true}, null: false, foreign_key: true
      t.integer :birth_sex_code, null: false
      t.integer :desired_sex_code

      t.timestamps
    end
  end
end
