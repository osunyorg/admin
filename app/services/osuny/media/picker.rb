class Osuny::Media::Picker
  attr_accessor :university, :language, :params, :about, :key

  def initialize(about: nil)
    @about = about unless about.nil?
  end

  def params=(value)
    @params = value
    import_from_params
  end

  def to_hash
    {
      about: {
        type: about.class.polymorphic_name,
        id: about.id,
        name: about.to_s,
      },
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

  def key
    @key ||= :featured_image
  end

  def image_property
    @image_property ||= key
  end

  def image
    @image ||= about.public_send(image_property)
  end

  def alt_property
    @alt_property ||= "#{key}_alt".to_sym
  end

  def alt
    @alt ||= about.public_send(alt_property)
  end

  def credit_property
    @credit_property ||= "#{key}_credit".to_sym
  end

  def credit
    @credit ||= about.public_send(credit_property)
  end

  def url
    @url ||= image.attached? ? "/media/#{ image&.signed_id }/preview.jpg" : ''
  end

  def about_type
    @about_type ||= params.dig(:about, :type)
  end

  def about_id
    @about_id ||= params.dig(:about, :id)
  end

  def about
    @about ||= about_type.constantize.find_by(university: university, id: about_id)
  end

  protected

  def import_from_params
    about.update_column(alt_property, params.dig(:image, :alt))
    about.update_column(credit_property, params.dig(:image, :credit))
    origins.import
    about.touch
  end

  def origins
    @origins ||= Osuny::Media::Picker::Origins.new(self)
  end
end