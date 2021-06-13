class ChangePersonBirthdaysToPersonBirthdates < ActiveRecord::Migration[6.0]
  def change
    rename_table :person_birthdays, :person_birthdates
  end
end
