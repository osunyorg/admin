# == Schema Information
#
# Table name: communication_website_post_category_localizations
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :string
#  featured_image_credit    :text
#  meta_description         :text
#  name                     :string
#  path                     :string
#  slug                     :string
#  summary                  :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_about_id_6e430d4efc                  (about_id)
#  idx_on_communication_website_id_0c06c1ae6f  (communication_website_id)
#  idx_on_language_id_cc5f73e306               (language_id)
#  idx_on_university_id_fb03a6e3c0             (university_id)
#
# Foreign Keys
#
#  fk_rails_04d5596411  (communication_website_id => communication_websites.id)
#  fk_rails_49ba67b5ed  (university_id => universities.id)
#  fk_rails_9edc398287  (about_id => communication_website_post_categories.id)
#  fk_rails_e1dc625b2e  (language_id => languages.id)
#
class Communication::Website::Post::Category::Localization < ApplicationRecord
  include AsLocalization
  include AsLocalizedTree
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include WithBlobs
  include WithFeaturedImage
  include WithGitFiles
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  validates :name, presence: true

  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    prefix = git_path_content_prefix(website)
    slugs = slug_with_ancestors_slugs(separator: '-')
    "#{prefix}posts_categories/#{slugs}/_index.html"
  end

  def template_static
    "admin/communication/websites/posts/categories/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def best_featured_image_source(fallback: true)
    return self if featured_image.attached?
    parent_category = about.parent
    parent_category_l10n = parent_category&.localization_for(language)
    if parent_category_l10n.present?
      best_source = parent_category_l10n&.best_featured_image_source(fallback: false)
    end
    best_source ||= self if fallback
    best_source
  end

  def to_s
    "#{name}"
  end

  protected

  def slug_unavailable?(slug)
    self.class.unscoped.where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug).where.not(id: self.id).exists?
  end

  def explicit_blob_ids
    super.concat [best_featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end
end
