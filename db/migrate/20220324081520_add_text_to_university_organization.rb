class AddTextToUniversityOrganization < ActiveRecord::Migration[6.1]
  def change
    add_column :university_organizations, :text, :text
  end
end
