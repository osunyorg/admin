class Communication::Website::Post::Category::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include Sluggable
  include WithBlobs
  include WithFeaturedImage
  include WithGitFiles
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id
  
  validates :name, presence: true

  def git_path(website)
    "#{git_path_content_prefix(website)}posts_categories/#{slug_with_ancestors_slugs}/_index.html"
  end

  def template_static
    "admin/communication/websites/posts/categories/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def slug_with_ancestors_slugs
    (ancestors.map(&:slug) << slug).join('-')
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
end
