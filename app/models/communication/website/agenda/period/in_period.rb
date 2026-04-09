module Communication::Website::Agenda::Period::InPeriod
  extend ActiveSupport::Concern

  included do
    before_validation :set_time_zone
    before_validation :set_to_day

    validates :from_day, presence: true
    validate  :year_is_a_four_digit_number,
              :to_day_after_from_day,
              :to_hour_after_from_hour_on_same_day
  end

  def same_day?
    from_day == to_day
  end

  def duration_in_days
    to_day.nil? ? 1 : (to_day - from_day).to_i
  end

  # Un événement demain aura une distance de 1, comme un événement hier
  # On utilise cette info pour classer les événements à venir dans un sens et les archives dans l'autre
  def distance_in_days
    (Date.current - from_day).to_i.abs
  end

  def from_year
    return if from_day.nil?
    @from_year ||= year_for(from_day.year)
  end

  def to_year
    return if to_day.nil?
    @to_year ||= year_for(to_day.year)
  end

  protected

  def year_for(value)
    Communication::Website::Agenda::Period::Year.find_by(
      university: university,
      website: website,
      value: value
    )
  end

  def set_time_zone
    self.time_zone = website.default_time_zone if respond_to?(:time_zone=) && self.time_zone.blank?
  end

  def set_to_day
    self.to_day = self.from_day if respond_to?(:to_day=) && self.to_day.nil?
  end

  def year_is_a_four_digit_number
    errors.add(:from_day, :invalid_year) if from_day.present? && !(1000..9999).include?(from_day.year)
    errors.add(:to_day, :invalid_year) if to_day.present? && !(1000..9999).include?(to_day.year)
  end

  def to_day_after_from_day
    errors.add(:to_day, :too_soon) if from_day.present? && to_day.present? && to_day < from_day
  end

  def to_hour_after_from_hour_on_same_day
    return if from_day != to_day
    return unless respond_to?(:from_hour) && respond_to?(:to_hour)
    errors.add(:to_hour, :too_soon) if to_hour.present? && from_hour.present? && to_hour <= from_hour
  end

end
