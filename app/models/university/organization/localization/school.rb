# == Schema Information
#
# Table name: university_organization_localizations
#
#  id                    :uuid             not null, primary key
#  address_additional    :string
#  address_name          :string
#  deleted_at            :datetime
#  featured_image_alt    :string
#  featured_image_credit :text
#  linkedin              :string
#  long_name             :string
#  mastodon              :string
#  meta_description      :text
#  migration_identifier  :string
#  name                  :string
#  published             :boolean          default(TRUE)
#  published_at          :datetime
#  slug                  :string
#  summary               :text
#  text                  :text
#  twitter               :string
#  url                   :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             uniquely indexed => [language_id], indexed
#  language_id           :uuid             uniquely indexed => [about_id], indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_eb921fd47b                        (about_id,language_id) UNIQUE
#  index_university_organization_localizations_on_about_id       (about_id)
#  index_university_organization_localizations_on_language_id    (language_id)
#  index_university_organization_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_19fb4f0718  (about_id => university_organizations.id)
#  fk_rails_4b46ee9073  (language_id => languages.id)
#  fk_rails_ba221edb00  (university_id => universities.id)
#
class University::Organization::Localization::School < University::Organization::Localization
  def self.polymorphic_name
    'University::Organization::Localization::School'
  end

  def git_path_relative
    "schools/#{slug}/_index.html"
  end

  def template_static
    "admin/university/organizations/schools/static"
  end

  def dependencies
    [
      organization_l10n,
      organization
    ]
  end

  def references
    # TODO
  end

  def static_localization_key
    # so we don't mess with the University::Organization::Localization static_localization_key
    "#{about.class.polymorphic_name.parameterize}-school-#{self.about_id}"
  end

end
