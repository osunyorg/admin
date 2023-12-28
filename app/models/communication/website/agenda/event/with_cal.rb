module Communication::Website::Agenda::Event::WithCal
  extend ActiveSupport::Concern

  def cal
    @cal ||= AddToCalendar::URLs.new(
      start_datetime: from_time, 
      end_datetime: to_time,
      timezone: timezone.name,
      title: "#{title} #{subtitle}",
      url: url,
      description: summary,
      all_day: (from_hour.nil? && to_hour.nil?)
    )
  end

  protected

  def from_time
    from_hour.nil?  ? from_day.to_time
                    : date_and_time(from_day, from_hour)
  end

  def to_time
    if to_day.nil? && to_hour.nil?
      # Pas de fin
      nil
    elsif to_day.nil? && to_hour.present?
      # Heure de fin sans jour de fin, donc on se base sur le jour de début
      date_and_time(from_day, to_hour)
    elsif to_day.present? && to_hour.nil?
      # Jour de fin seul
      to_day.to_time
    elsif to_day.present? && to_hour.nil?
      # Jour et heure de fin
      date_and_time(to_day, to_hour)
    end
  end

  def timezone
    # FIXME la timezone est Europe/Paris pour tout
    Time.zone
  end

  def date_and_time(date, time)
    Time.new  date.year,
              date.month,
              date.day,
              time.hour,
              time.min,
              time.sec,
              timezone
  end

end
