class Osuny::Media::Picker::Origins
  attr_reader :picker
  delegate  :params, :university, :about, :image, :image_property, :alt, :credit,
            to: :picker

  def initialize(picker)
    @picker = picker
  end

  # Empty origins, for initialization purpose
  def to_hash
    {
      blob: {
        id: '',
        signed_id: '',
        delete: false
      },
      cloud: {
        pexels: {
          id: '',
          url: '',
        },
        unsplash: {
          id: '',
          url: '',
        },
      },
      medias: {
        id: '',
      },
    }
  end

  def import
    return if nothing_changed?
    clean_previous_blob
    if blob_id.present?
      import_blob
    elsif cloud_unsplash_id.present?
      import_cloud_unsplash
    elsif cloud_pexels_id.present?
      import_cloud_pexels
    elsif media_id.present?
      import_medias
    end
  end

  protected

  def nothing_changed?
    params[:origin].deep_symbolize_keys == to_hash
  end

  def blob_id
    params.dig(:origin, :blob, :id)
  end

  def blob
    @blob ||= ActiveStorage::Blob.find_by(university_id: university.id, id: blob_id)
  end

  def cloud_unsplash_id
    params.dig(:origin, :cloud, :unsplash, :id)
  end

  def cloud_unsplash
    @cloud_unsplash ||= Unsplash::Photo.find cloud_unsplash_id
  end

  def cloud_pexels_id
    params.dig(:origin, :cloud, :pexels, :id)
  end

  def cloud_pexels
    @cloud_pexels ||= Pexels::Client.new.photos.find cloud_pexels_id
  end

  def media_id
    @media_id ||= params.dig(:origin, :medias, :id)
  end

  def media
    @media ||= Communication::Media.find_by(university: university, id: media_id)
  end

  def delete?
    params.dig(:origin, :blob, :delete)
  end

  def import_blob
    find_or_create_media_with_checksum(blob.checksum, :upload)
    attach_media_to_about
  end

  def import_cloud_unsplash
    url = "#{cloud_unsplash['urls']['full']}&w=2048&fit=max"
    filename = "#{cloud_unsplash.slug}.jpg"
    create_blob_from_url(url, filename)
    cloud_unsplash.track_download
    find_or_create_media_with_checksum(blob.checksum, :unsplash)
    attach_media_to_about
  end

  def import_cloud_pexels
    url = "#{cloud_pexels.src['original']}?auto=compress&cs=tinysrgb&w=2048"
    filename = "#{cloud_pexels.id}.png"
    create_blob_from_url(url, filename)
    find_or_create_media_with_checksum(blob.checksum, :pexels)
    attach_media_to_about
  end

  def import_medias
    attach_media_to_about
  end

  # Utilities

  def clean_previous_blob
    # Delete context
    Communication::Media::Context.where(
      university: university,
      about: about,
      active_storage_blob: image.blob
    ).destroy_all
    # Detach image (attachment)
    image.detach
  end
  
  def find_or_create_media_with_checksum(checksum, origin)
    if Communication::Media.where(university: university, original_checksum: checksum).exists?
      @media = Communication::Media.find_by(
        university: university, 
        original_checksum: checksum
      )
    else
      @media = Communication::Media.create_from_blob(
        blob, 
        in_context: about,
        origin: origin,
        alt: alt, 
        credit: credit
      )
    end
  end

  def create_blob_from_url(url, filename)
    ActiveStorage::Utils.attach_from_url(image, url, filename: filename)
    @blob = image.blob
  end

  def attach_media_to_about
    media.attach(about, image_property)
    picker.image_reset!
  end
end