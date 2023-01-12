module WithFeaturedImage
  extend ActiveSupport::Concern

  included do
    has_one_attached_deletable :featured_image

    validates :featured_image, size: { less_than: 5.megabytes }
  end

  # Can be overwrite to get featured_image from associated objects (ex: parents)
  def best_featured_image(fallback: true)
    featured_image
  end

  def add_unsplash_image(id)
    return if id.blank?
    photo = Unsplash::Photo.find id
    url = photo['urls']['full']
    filename = "#{photo['id']}.jpg"
    begin
      file = URI.open url
      featured_image.attach(io: file, filename: filename)
      photo.track_download
    rescue
    end
  end
end
