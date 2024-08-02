class Communication::Website::Portfolio::Project::Localization < ApplicationRecord
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
  include WithUniversity

  validates :title, presence: true

  scope :ordered, -> { order(year: :desc, title: :asc) }
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  scope :latest, -> { published.order(updated_at: :desc).limit(5) }

  # TODO L10N : To adapt
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_website_portfolio_projects.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_portfolio_projects.summary) ILIKE unaccent(:term) OR
      unaccent(communication_website_portfolio_projects.title) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def git_path(website)
    return unless website.id == communication_website_id && published
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    "projects/#{year}-#{slug}.html"
  end

  def template_static
    "admin/communication/websites/portfolio/projects/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def to_s
    "#{title}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def explicit_blob_ids
    super.concat [
      featured_image&.blob_id,
      shared_image&.blob_id
    ]
  end

end
