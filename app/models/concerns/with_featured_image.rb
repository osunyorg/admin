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
    origin = photo_origin(params)
    case origin
    when :unsplash
      photo_import_unsplash(params['unsplash'])
      register_featured_image_in_media_library
    when :pexels
      photo_import_pexels(params['pexels'])
      register_featured_image_in_media_library
    when :media
      photo_import_media(params['media'])
    end
  end

  protected

  def photo_origin(params)
    if params&.dig(:unsplash).present?
      :unsplash
    elsif params&.dig(:pexels).present?
      :pexels
    elsif params&.dig(:media).present?
      :media
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

  def photo_import_media(id)
    media = Communication::Media.find(id)
    featured_image.attach(media.original_blob)
    context = media.contexts.where(
      university_id: media.university_id,
      active_storage_blob_id: media.original_blob_id,
      about: self
    ).first_or_create
  end

  def register_featured_image_in_media_library
    Communication::Media.create_from_blob(
      featured_image.blob, 
      in_context: self, 
      origin: origin,
      alt: featured_image_alt,
      credit: featured_image_credit
    )
  end
end
