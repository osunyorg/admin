module Communication::Website::Agenda::Period::InPeriod
  extend ActiveSupport::Concern

  STATUS_FUTURE = 'future'
  STATUS_CURRENT = 'current'
  STATUS_ARCHIVE = 'archive'

  included do
    scope :future, -> {
      where('from_day > :today', today: Date.today)
    }
    scope :current, -> {
      where('(from_day <= :today AND to_day IS NULL) OR (from_day <= :today AND to_day >= :today)', today: Date.today)
    }
    scope :future_or_current, -> {
      future.or(current)
    }
    scope :archive, -> {
      where('to_day < :today', today: Date.today)
    }
    scope :past, -> { archive }

    before_validation :set_time_zone
    before_validation :set_to_day

    before_save :touch_periods
    after_save :create_periods

    validates :from_day, presence: true
    validate :to_day_after_from_day, :to_hour_after_from_hour_on_same_day
  end

  def status
    if future?
      STATUS_FUTURE
    elsif current?
      STATUS_CURRENT
    else
      STATUS_ARCHIVE
    end
  end

  def future?
    from_day > Date.today
  end

  def current?
    to_day.present? ? (Date.today >= from_day && Date.today <= to_day)
                    : from_day <= Date.today # Les événements sans date de fin restent actifs
  end

  def archive?
    to_day.present? ? to_day < Date.today
                    : false # Les événements sans date de fin restent actifs
  end

  def same_day?
    from_day == to_day
  end

  # Un événement demain aura une distance de 1, comme un événement hier
  # On utilise cette info pour classer les événements à venir dans un sens et les archives dans l'autre
  def distance_in_days
    (Date.today - from_day).to_i.abs
  end

  protected

  def set_time_zone
    self.time_zone = website.default_time_zone if self.time_zone.blank?
  end

  def set_to_day
    self.to_day = self.from_day if respond_to?(:to_day=) && self.to_day.nil?
  end

  def to_day_after_from_day
    errors.add(:to_day, :too_soon) if to_day.present? && to_day < from_day
  end

  def to_hour_after_from_hour_on_same_day
    return if from_day != to_day
    return unless respond_to?(:from_hour) && respond_to?(:to_hour)
    errors.add(:to_hour, :too_soon) if to_hour.present? && from_hour.present? && to_hour <= from_hour
  end

  def day_changed?
    raise NotImplementedError
  end

  def day_before_change
    raise NotImplementedError
  end

  def day_after_change
    raise NotImplementedError
  end

  def years_concerned_by_change
    [day_before_change&.year, day_after_change&.year].uniq.compact
  end

  def touch_periods
    # Periods might not exist yet!
    # If so, no problem, they will be properly initialized by create_periods
    return unless day_changed?
    touch_day(day_before_change)
    touch_day(day_after_change)
    years_concerned_by_change.each do |year|
      save_and_sync_year(year)
    end
  end

  def touch_day(date)
    return if date.nil?
    Communication::Website::Agenda::Period::Day.find_by(
      university: university,
      website: website,
      date: date
    )&.touch
  end

  def save_and_sync_year(year_value)
    Communication::Website::Agenda::Period::Year.find_by(
      university: university,
      website: website,
      value: year_value
    )&.save_and_sync
  end

  def create_periods
    Communication::Website::Agenda::CreatePeriodsJob.perform_later(self)
  end
end
