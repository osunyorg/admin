# == Schema Information
#
# Table name: administration_location_localizations
#
#  id                    :uuid             not null, primary key
#  address_additional    :string
#  address_name          :string
#  deleted_at            :datetime
#  featured_image_credit :text
#  featured_media_alt    :string
#  meta_description      :string
#  name                  :string
#  slug                  :string
#  summary               :text
#  url                   :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             uniquely indexed => [language_id], indexed
#  featured_media_id     :uuid             indexed
#  language_id           :uuid             uniquely indexed => [about_id], indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_cf0b216983                        (about_id,language_id) UNIQUE
#  idx_on_featured_media_id_7befd34d61                           (featured_media_id)
#  index_administration_location_localizations_on_about_id       (about_id)
#  index_administration_location_localizations_on_language_id    (language_id)
#  index_administration_location_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_620edcdb56  (language_id => languages.id)
#  fk_rails_a1f1479544  (university_id => universities.id)
#  fk_rails_a4a4f31786  (about_id => administration_locations.id)
#  fk_rails_d2ab7f56df  (featured_media_id => communication_medias.id) ON DELETE => nullify
#
class Administration::Location::Localization < ApplicationRecord
  acts_as_paranoid

  include AsLocalization
  include Contentful
  include HasBlobs
  include HasFeaturedMedia
  include HasGitFiles
  include HasUniversity
  include Initials
  include Permalinkable
  include Sanitizable
  include Accessible

  has_summernote :summary

  def git_path_relative
    "locations/#{slug}/_index.html"
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
      featured_media&.original_blob_id,
    ]
  end

end
