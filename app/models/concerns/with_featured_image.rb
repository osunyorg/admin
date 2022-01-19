module WithFeaturedImage
  extend ActiveSupport::Concern

  included do
    has_one_attached_deletable :featured_image
  end

  # Can be overwrite to get featured_image from associated objects (ex: parents)
  def best_featured_image(fallback: true)
    featured_image
  end
end
