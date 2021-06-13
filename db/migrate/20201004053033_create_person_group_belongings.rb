class CreatePersonGroupBelongings < ActiveRecord::Migration[6.0]
  def change
    create_table :person_group_belongings, id: false do |t|
      t.references :person, index: {:unique=>true}, null: false, foreign_key: true
      t.references :person_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
