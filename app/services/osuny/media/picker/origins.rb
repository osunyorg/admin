class Osuny::Media::Picker::Origins
  attr_reader :picker
  delegate  :params, :university, :about, :media, :alt, :credit,
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
    if blob_id.present?
      import_blob
    elsif cloud_unsplash_id.present?
      import_cloud_unsplash
    elsif cloud_pexels_id.present?
      import_cloud_pexels
    elsif media_id.present?
      import_medias
    elsif delete?
      remove_media
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

  def selected_media
    @selected_media ||= Communication::Media.find_by(university: university, id: media_id)
  end

  def delete?
    params.dig(:origin, :blob, :delete)
  end

  def import_blob
    set_media find_or_create_media_from_blob(:upload)
  end

  def import_cloud_unsplash
    url = "#{cloud_unsplash['urls']['full']}&w=2048&fit=max"
    filename = "#{cloud_unsplash.slug}.jpg"
    create_blob_from_url(url, filename)
    cloud_unsplash.track_download
    set_media find_or_create_media_from_blob(:unsplash)
  end

  def import_cloud_pexels
    url = "#{cloud_pexels.src['original']}?auto=compress&cs=tinysrgb&w=2048"
    filename = "#{cloud_pexels.id}.png"
    create_blob_from_url(url, filename)
    set_media find_or_create_media_from_blob(:pexels)
  end

  def import_medias
    set_media selected_media
  end

  def remove_media
    clean_context
    picker.media = nil
  end

  # Utilities

  # The object keeps a link to the media, and the media keeps a context,
  # to know where it is used.
  def set_media(new_media)
    return if new_media.nil?
    clean_context
    Communication::Media.create_context(new_media, new_media.original_blob, about)
    picker.media = new_media
  end

  def clean_context
    Communication::Media::Context.where(
      university: university,
      about: about,
      communication_media: media
    ).destroy_all
  end

  def find_or_create_media_from_blob(origin)
    Communication::Media.where(
      university: university,
      original_checksum: blob.checksum
    ).first ||
    Communication::Media.find_or_create_from_blob(
      blob,
      in_context: about,
      origin: origin,
      alt: alt,
      credit: credit
    )
  end

  def create_blob_from_url(url, filename)
    @blob = ActiveStorage::Utils.blob_from_url(url, filename: filename)
    @blob&.update_column(:university_id, university.id)
    @blob
  end
end
