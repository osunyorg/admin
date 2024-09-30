class ChangeRolesAndInvolvementsDescriptionType < ActiveRecord::Migration[7.1]
  def up
    change_column :university_role_localizations, :description, :string
    change_column :university_person_involvement_localizations, :description, :string
  end
  def down
    change_column :university_role_localizations, :description, :text
    change_column :university_person_involvement_localizations, :description, :text
  end
end
