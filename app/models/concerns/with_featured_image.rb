module WithFeaturedImage
  extend ActiveSupport::Concern

  included do
    has_summernote :featured_image_credit
    has_one_attached_deletable :featured_image

    validates :featured_image, size: { less_than: 5.megabytes }
  end

  # Can be overwrite to get featured_image from associated objects (ex: parents)
  def best_featured_image_source(fallback: true)
    self
  end

  def best_featured_image
    best_featured_image_source.featured_image
  end

  def best_featured_image_alt
    best_featured_image_source.featured_image_alt
  end

  def best_featured_image_credit
    best_featured_image_source.featured_image_credit
  end
end
