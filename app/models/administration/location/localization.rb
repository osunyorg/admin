# == Schema Information
#
# Table name: administration_location_localizations
#
#  id                    :uuid             not null, primary key
#  address_additional    :string
#  address_name          :string
#  featured_image_alt    :string
#  featured_image_credit :text
#  meta_description      :string
#  name                  :string
#  slug                  :string
#  summary               :text
#  url                   :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             indexed
#  language_id           :uuid             indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  index_administration_location_localizations_on_about_id       (about_id)
#  index_administration_location_localizations_on_language_id    (language_id)
#  index_administration_location_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_620edcdb56  (language_id => languages.id)
#  fk_rails_a1f1479544  (university_id => universities.id)
#  fk_rails_a4a4f31786  (about_id => administration_locations.id)
#
class Administration::Location::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include HasGitFiles
  include Initials
  include Permalinkable
  include Sanitizable
  include WithAccessibility
  include WithBlobs
  include WithFeaturedImage
  include WithUniversity

  has_summernote :summary

  def git_path(website)
    "#{git_path_content_prefix(website)}locations/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/administration/locations/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def to_s
    "#{name}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def explicit_blob_ids
    super.concat [
      featured_image&.blob_id,
    ]
  end

end
