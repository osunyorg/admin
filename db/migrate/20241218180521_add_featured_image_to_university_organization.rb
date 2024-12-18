class AddFeaturedImageToUniversityOrganization < ActiveRecord::Migration[7.2]
  def change
    add_column :university_organization_localizations, :featured_image_alt, :string
    add_column :university_organization_localizations, :featured_image_credit, :text
  end
end
