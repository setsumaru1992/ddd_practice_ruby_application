class CreateTopPersonGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :top_person_groups, id: false do |t|
      t.references :person_group, index: {:unique=>true}, null: false, foreign_key: true

      t.timestamps
    end
  end
end
