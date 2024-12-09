class Osuny::AddressFormatter

  attr_reader :about, :l10n, :language

  def initialize(about:, l10n: nil, language:)
    @about = about
    @l10n = l10n
    @language = language
  end

  def present?
    to_s.present?
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
    html += add_if  address_name.present?,
                    " <span itemprop=\"name\">#{address_name}</span>"
    html += add_if  address.present?,
                    " <span itemprop=\"streetAddress\">#{address}</span>"
    html += add_if  address_additional.present?,
                    " <span itemprop=\"description\">#{address_additional}</span>"
    html += add_if  zipcode.present?,
                    " <span itemprop=\"postalCode\">#{zipcode}</span>"
    html += add_if  city.present?,
                    " <span itemprop=\"addressLocality\">#{city}</span>"
    html += add_if  country.present?,
                    " <span itemprop=\"addressCountry\">#{country&.upcase}</span>"
    html += '</address>'
    html
  end

  protected

  def add_if(condition, text)
    condition ? text : ''
  end

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