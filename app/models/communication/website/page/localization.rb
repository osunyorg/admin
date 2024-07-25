class Communication::Website::Page::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include Shareable
  include WithAccessibility
  include WithBlobs
  include WithFeaturedImage
  include WithGitFiles
  include WithPath # Must be included after Sluggable. WithPath overwrites the git_path method defined in WithWebsites
  include WithPublication
  include WithUniversity

  belongs_to  :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  validates :title, presence: true
  validates :header_cta_label, :header_cta_url, presence: true, if: :header_cta

  before_validation :set_communication_website_id

  def template_static
    "admin/communication/websites/pages/static"
  end

  def dependencies
    calculated_dependencies = []
    calculated_dependencies += active_storage_blobs
    calculated_dependencies += contents_dependencies
    calculated_dependencies += [website.config_default_content_security_policy]
    unless blocks.published.any?
      # children are used only if there is no block to display
      calculated_dependencies += about.children
    end
    calculated_dependencies
  end

  def best_breadcrumb_title
    breadcrumb_title.presence || title
  end

  def to_s
    "#{title}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end

  def explicit_blob_ids
    super.concat [
      featured_image&.blob_id,
      shared_image&.blob_id
    ]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end

  def localize_other_attachments(localization)
    localize_attachment(localization, :shared_image) if shared_image.attached?
  end

end