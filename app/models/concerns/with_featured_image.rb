module WithFeaturedImage
  extend ActiveSupport::Concern

  included do
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

  def add_unsplash_image(id)
    return if id.blank?
    photo = Unsplash::Photo.find id
    url = "#{photo['urls']['full']}&w=2048&fit=max"
    filename = "#{photo['id']}.jpg"
    begin
      file = URI.open url
      featured_image.attach(io: file, filename: filename)
      photo.track_download
    rescue
    end
  end
end
