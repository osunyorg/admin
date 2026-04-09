module Communication::Website::Agenda::Event::WithPeriodSync
  extend ActiveSupport::Concern

  included do
    after_save_commit :sync_periods_later
    after_destroy :sync_periods_later
    after_restore :sync_periods_later
  end

  def sync_periods_safely
    dates_concerned.each { |date| touch_period_day(date) }
    months_concerned.each { |date| save_period_month(date) }
    years_concerned.each { |year| save_period_year(year) }
  end

  protected

  def sync_periods_later
    Communication::Website::Agenda::Event::SyncPeriodsJob.perform_later(self)
  end

  def dates_concerned
    (
      dates_concerned_from_self +
      dates_concerned_from_time_slots
    ).flatten.uniq.compact
  end

  def dates_concerned_from_self
    [
      from_day,
      from_day_previous_change&.first,
      to_day,
      to_day_previous_change&.first
    ]
  end

  def dates_concerned_from_time_slots
    time_slots.collect(&:dates_concerned)
  end

  # Ruby dates symbolizing first days of each month concerned
  # [19 Nov 2025, 20 Nov 2025] => [1 Nov 2025]
  def months_concerned
    dates_concerned.map(&:beginning_of_month).uniq
  end

  def years_concerned
    dates_concerned.map(&:year).uniq
  end

  def touch_period_day(date)
    return if date.nil?
    period_day = Communication::Website::Agenda::Period::Day.find_by(
      university: university,
      website: website,
      date: date
    )
    period_day.touch if period_day
  end

  def save_period_month(date)
    return if date.nil?
    period_year = year_for(date.year)
    return if period_year.nil?
    period_month = Communication::Website::Agenda::Period::Month.find_by(
      university: university,
      website: website,
      year: period_year,
      value: date.month
    )
    period_month.save if period_month
  end

  def save_period_year(year_value)
    return if year_value.nil?
    period_year = year_for(year_value)
    period_year.save if period_year
  end
end
