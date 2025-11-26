module Communication::Website::Agenda::Period::InPeriod
  extend ActiveSupport::Concern

  included do
    before_validation :set_time_zone
    before_validation :set_to_day

    before_save :touch_periods
    after_save :create_periods
    after_destroy :sync_periods
    after_restore :sync_periods if respond_to?(:after_restore)

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
    errors.add(:to_day, :too_soon) if to_day.present? && to_day < from_day
  end

  def to_hour_after_from_hour_on_same_day
    return if from_day != to_day
    return unless respond_to?(:from_hour) && respond_to?(:to_hour)
    errors.add(:to_hour, :too_soon) if to_hour.present? && from_hour.present? && to_hour <= from_hour
  end

  # By default, no update
  # Event and time slots will override that
  def should_update_periods?
    false
  end

  def day_before_change
    raise NoMethodError, "You must implement the `day_before_change` method in #{self.class.name}"
  end

  def day_after_change
    raise NoMethodError, "You must implement the `day_after_change` method in #{self.class.name}"
  end

  def years_concerned_by_change
    [day_before_change&.year, day_after_change&.year].uniq.compact
  end

  def touch_periods
    # Periods might not exist yet!
    # If so, no problem, they will be properly initialized by create_periods
    return unless should_update_periods?
    touch_day(day_before_change)
    touch_day(day_after_change)
    years_concerned_by_change.each do |year|
      save_year(year)
    end
    save_month(day_after_change)
    different_months = (day_after_change&.strftime('%Y%m') != day_before_change&.strftime('%Y%m'))
    save_month(day_before_change) if different_months
  end

  def touch_day(date)
    return if date.nil?
    Communication::Website::Agenda::Period::Day.find_by(
      university: university,
      website: website,
      date: date
    )&.touch
  end

  def save_year(year_value)
    year_for(year_value)&.save
  end

  def save_month(date)
    return if date.nil?
    year = year_for(date.year)
    Communication::Website::Agenda::Period::Month.find_by(
      university: university,
      website: website,
      year: year,
      value: date.month
    )&.save
  end

  def create_periods
    # Not for:
    # Communication::Website::Agenda::Exhibition
    # Communication::Website::Agenda::Event::Day
    return unless is_a?(Communication::Website::Agenda::Event) ||
                  is_a?(Communication::Website::Agenda::Event::TimeSlot)
    Communication::Website::Agenda::CreatePeriodsJob.perform_later(self)
  end

  def sync_periods
    touch_day(from_day)
    touch_day(to_day) if from_day != to_day
    from_year&.needs_recheck!
    # le if sert à économiser un update_column
    to_year&.needs_recheck! if to_year != from_year
  end
end
