module Communication::Website::Agenda::WithStatus
  extend ActiveSupport::Concern

  STATUS_FUTURE = 'future'
  STATUS_CURRENT = 'current'
  STATUS_ARCHIVE = 'archive'

  included do
    scope :future, -> {
      where('from_day > :today', today: Date.today)
    }
    scope :current, -> {
      where('from_day <= :today AND to_day >= :today', today: Date.today)
    }
    scope :future_or_current, -> {
      future.or(current)
    }
    scope :archive, -> {
      where('to_day < :today', today: Date.today)
    }
    scope :changed_status_today, -> {
      where(
        'from_day = :today OR from_day = :yesterday OR to_day = :today OR to_day = :yesterday',
        today: Date.today,
        yesterday: Date.yesterday
      )
    }
    scope :past, -> { archive }
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
    Date.today >= from_day && Date.today <= to_day
  end

  def archive?
    to_day < Date.today
  end

end
