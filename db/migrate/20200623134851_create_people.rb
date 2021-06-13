class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string :id_param

      t.timestamps
    end
    add_index :people, :id_param, unique: true
  end
end
