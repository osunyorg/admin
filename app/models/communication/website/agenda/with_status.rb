module Communication::Website::Agenda::WithStatus
  extend ActiveSupport::Concern

  def status
    if future?
      Communication::Website::Agenda::STATUS_FUTURE
    elsif current?
      Communication::Website::Agenda::STATUS_CURRENT
    else
      Communication::Website::Agenda::STATUS_ARCHIVE
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
