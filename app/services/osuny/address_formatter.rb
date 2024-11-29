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

  def address_name
    l10n.try(:address_name)
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

  def country_alpha2
    country_object&.alpha2 || country
  end

  def country_alpha3
    country_object&.alpha3 || country
  end

  def to_s
    ActionController::Base.helpers.strip_tags(to_html)
  end

  # <address itemprop="address" itemscope itemtype="https://schema.org/PostalAddress">
  #   <span itemprop="name">noesya</span>
  #   <span itemprop="streetAddress">15 rue des Bouviers</span>
  #   <span itemprop="description">Quartier Saint-Michel</span>
  #   <span itemprop="postalCode">33000</span> <span itemprop="addressLocality">Bordeaux</span>
  #   <span itemprop="addressCountry">FRANCE</span>
  # </address>
  def to_html
    html = '<address itemprop="address" itemscope itemtype="https://schema.org/PostalAddress">'
    html += " <span itemprop=\"name\">#{address_name}</span>" if address_name.present?
    html += " <span itemprop=\"streetAddress\">#{address}</span>" if address.present?
    html += " <span itemprop=\"description\">#{address_additional}</span>" if address_additional.present?
    html += " <span itemprop=\"postalCode\">#{zipcode}</span>" if zipcode.present?
    html += " <span itemprop=\"addressLocality\">#{city}</span>" if city.present?
    html += " <span itemprop=\"addressCountry\">#{country.upcase}</span>" if country.present?
    html += '</address>'
    html
  end

  protected

  def country_string
    about.try(:country)
  end

  def country_object
    if country_string.in? ISO3166::Country.codes
      ISO3166::Country[country_string]
    else
      ISO3166::Country.find_country_by_any_name country_string
    end
  end
end