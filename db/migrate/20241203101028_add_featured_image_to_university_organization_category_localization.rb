class AddFeaturedImageToUniversityOrganizationCategoryLocalization < ActiveRecord::Migration[7.2]
  def change
    add_column :university_organization_category_localizations, :featured_image_alt, :text
    add_column :university_organization_category_localizations, :featured_image_credit, :text
    add_column :university_organization_category_localizations, :meta_description, :text
    add_column :university_organization_category_localizations, :summary, :text
  end
end
