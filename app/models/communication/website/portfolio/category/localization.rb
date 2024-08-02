class Communication::Website::Portfolio::Category::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include Initials
  include Permalinkable # We override slug_unavailable? method
  include Sanitizable
  include WithBlobs
  include WithFeaturedImage
  include WithGitFiles
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  validates :name, presence: true

  before_validation :set_communication_website_id

  def git_path(website)
    "#{git_path_content_prefix(website)}projects_categories/#{slug}/_index.html"
  end

  def template_static
    "admin/communication/websites/portfolio/categories/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def to_s
    "#{name}"
  end

  protected

  def slug_unavailable?(slug)
    self.class
        .unscoped
        .where(
          communication_website_id: self.communication_website_id,
          language_id: language_id,
          slug: slug
        )
        .where.not(id: self.id)
        .exists?
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end
end
