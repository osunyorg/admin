module WithCountry
  extend ActiveSupport::Concern

  def country_name
    return if country_iso.blank?
    country_iso.translations[I18n.locale.to_s] || country_common_name
  end

  def country_common_name
    return if country_iso.blank?
    country_iso.common_name || country_iso.iso_short_name
  end

  private

  def country_iso
    return @country_iso if defined?(@country_iso)
    @country_iso ||= country.blank? ? nil : ISO3166::Country[country]
  end
end
