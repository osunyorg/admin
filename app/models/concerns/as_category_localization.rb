module AsCategoryLocalization
  extend ActiveSupport::Concern

  include AsLocalization
  include AsLocalizedTree
  include Contentful
  include HasGitFiles
  include HeaderCallToAction
  include Initials
  include Permalinkable
  include Sanitizable
  include Shareable
  include WithBlobs
  include WithFeaturedImage
  include WithUniversity

  included do
    has_summernote :summary

    validates :name, presence: true
  end

  def template_static
    "admin/application/categories/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def references
    category_objects_localizations
  end

  def published?
    persisted?
  end

  def best_breadcrumb_title
    breadcrumb_title.presence || name
  end

  def to_s
    "#{name}"
  end

  protected

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [featured_image&.blob_id]
  end

  def hugo_slug_in_website(website)
    slug_with_ancestors_slugs
  end

  def category_objects_localizations
    category_objects_ids = about.category_objects.pluck(:id)
    localization_class_name = "#{about.category_objects.klass.name}::Localization"
    localization_class_name.constantize.unscoped.where(about_id: category_objects_ids)
  end
end
