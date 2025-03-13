module Communication::Website::WithTimeZone
  extend ActiveSupport::Concern

  included do
    before_validation :set_default_time_zone_if_blank, on: :create
  end

  def set_default_time_zone_if_blank
    return unless default_time_zone.blank?
    self.default_time_zone = Time.zone.name
  end
end