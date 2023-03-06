module WithGeolocation
  extend ActiveSupport::Concern

  included do
    geocoded_by :full_street_address

    after_validation :geocode, if: -> (geocodable) { geocodable.full_street_address_present? && geocodable.full_street_address_changed? }
  end

  def full_street_address
    "#{address}, #{zipcode} #{city} #{country}"
  end

  protected

  def full_street_address_present?
    address.present? || zipcode.present? || city.present?
  end

  def full_street_address_changed?
    address_changed? || zipcode_changed? || city_changed?
  end
end