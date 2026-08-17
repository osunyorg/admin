class Osuny::Media::Picker
  attr_accessor :university, :language, :params, :about

  def initialize(about: nil)
    @about = about unless about.nil?
    byebug
  end

  def params=(value)
    @params = value
    import_from_params
  end

  def to_hash
    {
      about: {
        about_type: about.class.polymorphic_name,
        about_id: about.id
      },
      media: '',
      image: {
        alt: alt,
        credit: credit,
        url: url,
      },
      origin: origins.to_hash
    }
  end

  def to_json
    to_hash.to_json
  end

  def media
    @media ||= about.featured_media
  end

  def media=(value)
    about.update_column(:featured_media_id, value&.id)
    @media = nil
    @url = nil
    about.reload
  end

  def blob
    media&.original_blob
  end

  def alt
    @alt ||= about.featured_media_alt
  end

  def credit
    @credit ||= about.featured_media_credit
  end

  def url
    return if blob.nil?
    @url ||= (ENV['KEYCDN_HOST'].present? ? keycdn_url : medium_url)
  end

  def about_type
    @about_type ||= params.dig(:about, :type)
  end

  def about_id
    @about_id ||= params.dig(:about, :id)
  end

  def about
    @about ||= PolymorphicObjectFinder.find(
      {
        about_type: about_type,
        about_id: about_id
      },
      key: :about,
      university: university,
      mandatory_module: HasFeaturedMedia
    )
  end

  protected

  def keycdn_url
    "https://#{ENV['KEYCDN_HOST']}/#{blob.key}?width=800"
  end

  def medium_url
    "/media/#{blob.signed_id}/preview_800x.png"
  end

  def import_from_params
    about.update_column(:featured_media_alt, params.dig(:image, :alt))
    origins.import
    import_credit
    about.touch
  end

  # Credit is not localized on the object, it belongs to the media itself
  def import_credit
    media_localization = about.featured_media_localization
    return if media_localization.nil?
    media_localization.update(credit: params.dig(:image, :credit))
  end

  def origins
    @origins ||= Osuny::Media::Picker::Origins.new(self)
  end
end
