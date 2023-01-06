class AddDescriptionShortToUniversityOrganization < ActiveRecord::Migration[7.0]
  def change
    add_column :university_organizations, :description_short, :text
  end
end
