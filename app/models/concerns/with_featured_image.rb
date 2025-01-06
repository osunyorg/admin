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

  def add_photo_import(params)
    photo_import_unsplash(params['unsplash']) if params['unsplash'].present?
    photo_import_pexels(params['pexels']) if params['pexels'].present?
    Communication::Media.create_from_blob(
      featured_image.blob, 
      in_context: self, 
      origin: photo_origin(params),
      alt: featured_image_alt,
      credit: featured_image_credit
    )
  end

  def photo_origin(params)
    if params['unsplash'].present?
      :unsplash
    elsif params['pexels'].present?
      :pexels
    else
      :upload
    end
  end

  def photo_import_unsplash(id)
    photo = Unsplash::Photo.find id
    url = "#{photo['urls']['full']}&w=2048&fit=max"
    filename = "#{photo['id']}.jpg"
    ActiveStorage::Utils.attach_from_url(featured_image, url, filename: filename)
    photo.track_download
  end

  def photo_import_pexels(id)
    photo = Pexels::Client.new.photos.find id
    url = "#{photo.src['original']}?auto=compress&cs=tinysrgb&w=2048"
    filename = "#{photo.id}.png"
    ActiveStorage::Utils.attach_from_url(featured_image, url, filename: filename)
  end
end
