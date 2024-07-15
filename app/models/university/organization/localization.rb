# == Schema Information
#
# Table name: university_organization_localizations
#
#  id                 :uuid             not null, primary key
#  address_additional :string
#  address_name       :string
#  linkedin           :string
#  long_name          :string
#  mastodon           :string
#  meta_description   :text
#  name               :string
#  slug               :string
#  summary            :text
#  text               :text
#  twitter            :string
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  about_id           :uuid             indexed
#  language_id        :uuid             indexed
#  university_id      :uuid             indexed
#
# Indexes
#
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
class University::Organization::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include Shareable
  include Sluggable
  include WithBlobs
  include WithGitFiles
  include WithUniversity

  has_summernote :text

  has_one_attached_deletable :logo
  has_one_attached_deletable :logo_on_dark_background

  alias :featured_image :logo

  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:university_id, :language_id]
  validates :logo, size: { less_than: 1.megabytes }
  validates :logo_on_dark_background, size: { less_than: 1.megabytes }
  # Organization can be created from extranet with only their name. Be careful for future validators.
  # There is an attribute accessor above : `created_from_extranet`

  def dependencies
    contents_dependencies +
    active_storage_blobs
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}organizations/#{slug}.html" if for_website?(website)
  end

  def template_static
    "admin/university/organizations/static"
  end

  def published?
    persisted?
  end

  def to_s
    "#{name}"
  end

  def explicit_blob_ids
    [
      logo&.blob_id,
      logo_on_dark_background&.blob_id,
      shared_image&.blob_id
    ]
  end

  protected

  def localize_other_attachments(localization)
    localize_attachment(localization, :logo) if logo.attached?
    localize_attachment(localization, :logo_on_dark_background) if logo_on_dark_background.attached?
    localize_attachment(localization, :shared_image) if shared_image.attached?
  end

end
