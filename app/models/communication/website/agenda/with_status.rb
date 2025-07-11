module Communication::Website::Agenda::WithStatus
  extend ActiveSupport::Concern

  STATUS_FUTURE = 'future'
  STATUS_CURRENT = 'current'
  STATUS_ARCHIVE = 'archive'

  included do
    scope :future, -> {
      where("#{table_name}.from_day > :today", today: Date.today)
    }
    scope :current, -> {
      where("#{table_name}.from_day <= :today AND #{table_name}.to_day >= :today", today: Date.today)
    }
    scope :future_or_current, -> {
      future.or(current)
    }
    scope :archive, -> {
      where("#{table_name}.to_day < :today", today: Date.today)
    }
    scope :changed_status_today, -> {
      where(
        "#{table_name}.from_day = :today OR #{table_name}.from_day = :yesterday OR #{table_name}.to_day = :today OR #{table_name}.to_day = :yesterday",
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
