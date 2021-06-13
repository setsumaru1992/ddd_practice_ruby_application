class CreatePersonBirthdays < ActiveRecord::Migration[6.0]
  def change
    create_table :person_birthdays, id: false do |t|
      t.references :person, index: {:unique=>true}, null: false, foreign_key: true
      t.integer :year
      t.integer :month
      t.integer :date

      t.timestamps
    end
  end
end
