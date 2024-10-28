module WithGeolocation
  extend ActiveSupport::Concern

  included do
    geocoded_by :full_street_address

    after_save_commit :geocode_in_background_if_necessary
  end

  def full_street_address
    "#{address}, #{zipcode} #{city} #{country}"
  end

  def full_address_in(language)
    l10n = localization_for(language)
    string = ""
    string += "#{l10n.address_name}<br>" if l10n&.address_name.present?
    string += "#{address}<br>" if address.present?
    string += "#{l10n.address_additional}<br>" if l10n&.address_additional.present?
    string += "#{zipcode} #{city}"
    string += "<br>#{country_common_name}" if country.present?
    string
  end

  def geolocated?
    latitude.present? && longitude.present?
  end

  def geocode_in_background_if_necessary
    return unless geocodable? && needs_new_geocoding?
    GeocodingJob.perform_later(self)
  end

  def latlong
    @latlong ||= [latitude, longitude]
  end

  def geo_point
    @geo_point ||= GeoPoint.new latitude, longitude
  end

  protected

  def geocodable?
    address.present? ||
    zipcode.present? ||
    city.present?
  end

  def needs_new_geocoding?
    saved_change_to_address? ||
    saved_change_to_zipcode? || 
    saved_change_to_city? ||
    saved_change_to_country?
  end
end
