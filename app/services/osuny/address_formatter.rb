class Osuny::AddressFormatter

  attr_reader :about, :l10n, :language

  def initialize(about:, l10n: nil, language:)
    @about = about
    @l10n = l10n
    @language = language
  end

  def address
    about.try(:address)
  end

  def address_additional
    l10n.try(:address_additional)
  end

  def zipcode
    about.try(:zipcode)
  end

  def city
    about.try(:city)
  end

  def country
    country_object&.to_s || country_string
  end

  def country_code
    country_object&.alpha2 || country
  end

  def to_s
    postal_address.gsub("\n", ' ')
  end

  def to_html
    "<p>#{postal_address.gsub("\n", "<br>")}</p>"
  end

  protected

  def postal_address
    @postal_address ||= Snail.new(
      line_1: address,
      line_2: address_additional,
      city: city,
      postal_code: zipcode,
      country: country_code
    ).to_s
  end

  def country_object
    if country_string.in? ISO3166::Country.codes
      ISO3166::Country[country_string]
    else
      ISO3166::Country.find_country_by_any_name country_string
    end
  end

  def country_string
    about.try(:country)
  end
end