module Communication::Website::WithTimeZone
  extend ActiveSupport::Concern

  included do
    before_validation :set_default_time_zone_if_blank
  end

  def set_default_time_zone_if_blank
    self.default_time_zone = default_time_zone.presence || Time.zone.name
  end
end