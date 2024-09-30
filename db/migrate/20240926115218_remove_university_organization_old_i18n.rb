class RemoveUniversityOrganizationOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :university_organizations, :original_id
    remove_column :university_organizations, :language_id
    remove_column :university_organizations, :address_additional
    remove_column :university_organizations, :address_name
    remove_column :university_organizations, :linkedin
    remove_column :university_organizations, :long_name
    remove_column :university_organizations, :mastodon
    remove_column :university_organizations, :meta_description
    remove_column :university_organizations, :name
    remove_column :university_organizations, :summary
    remove_column :university_organizations, :text
    remove_column :university_organizations, :twitter
    remove_column :university_organizations, :url

  end
end
