module WithGeolocation
  extend ActiveSupport::Concern

  included do
    geocoded_by :full_street_address

    after_validation :geocode, if: -> (geocodable) { geocodable.full_street_address_present? && geocodable.full_street_address_changed? }
  end

  def full_street_address
    "#{address}, #{zipcode} #{city} #{country}"
  end

  def full_address
    string = ""
    string += "#{address_name}<br>" if address_name.present?
    string += "#{address}<br>" if address.present?
    string += "#{address_additional}<br>" if address_additional.present?
    string += "#{zipcode} #{city}"
    string += "<br>#{ISO3166::Country[country]}" if country
    string
  end

  def geolocated?
    latitude.present? && longitude.present?
  end

  def latlong
    @latlong ||= [latitude, longitude]
  end

  def geo_point
    @geo_point ||= GeoPoint.new latitude, longitude
  end

  protected

  def full_street_address_present?
    address.present? || zipcode.present? || city.present?
  end

  def full_street_address_changed?
    address_changed? || zipcode_changed? || city_changed?
  end
end