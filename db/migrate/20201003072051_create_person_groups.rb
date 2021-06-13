class CreatePersonGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :person_groups do |t|
      t.string :id_param
      t.string :name

      t.timestamps
    end
    add_index :person_groups, :id_param, unique: true
  end
end
