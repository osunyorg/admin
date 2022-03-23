class ChangeMailToEmailForUniversityOrganizations < ActiveRecord::Migration[6.1]
  def change
    rename_column :university_organizations, :mail, :email
  end
end
