class RenameDispnameColumnToPersonNames < ActiveRecord::Migration[6.0]
  def change
    rename_column :person_names, :dispname, :disp_name
  end
end
