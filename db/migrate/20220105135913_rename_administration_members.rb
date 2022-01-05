class RenameAdministrationMembers < ActiveRecord::Migration[6.1]
  def change
    rename_table :administration_members, :university_people
  end
end
