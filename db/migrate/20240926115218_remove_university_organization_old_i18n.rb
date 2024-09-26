class RemoveUniversityOrganizationOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :university_organizations, :original_id
    remove_colum :university_organizations, :language_id
    remove_colum :university_organizations, :address_additional
    remove_colum :university_organizations, :address_name
    remove_colum :university_organizations, :linkedin
    remove_colum :university_organizations, :long_name
    remove_colum :university_organizations, :mastodon
    remove_colum :university_organizations, :meta_description
    remove_colum :university_organizations, :name
    remove_colum :university_organizations, :summary
    remove_colum :university_organizations, :text
    remove_colum :university_organizations, :twitter
    remove_colum :university_organizations, :url

  end
end
