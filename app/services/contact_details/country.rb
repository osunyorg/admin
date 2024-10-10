class ContactDetails::Country < ContactDetails::Base

  protected

  def prepare_label
    @label = country&.common_name || @string.to_s.titleize
  end

  def prepare_value
    @value = country&.alpha2 || @string.to_s[0..1].upcase
  end

  def country
    if @string.in? ISO3166::Country.codes
      ISO3166::Country[@string]
    else
      ISO3166::Country.find_country_by_any_name @string
    end
  end

end