class AddIdParamToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :id_param, :string
    add_index :users, :id_param, unique: true
  end
end
