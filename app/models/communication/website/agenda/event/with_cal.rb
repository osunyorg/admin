module Communication::Website::Agenda::Event::WithCal
  extend ActiveSupport::Concern

  def cal
    @cal ||= AddToCalendar::URLs.new(
      start_datetime: cal_from_time, 
      end_datetime: cal_to_time,
      timezone: timezone.name,
      all_day: cal_all_day,
      title: "#{title} #{subtitle}",
      url: url,
      description: summary
    )
  end

  protected

  def cal_from_time
    from_hour.nil?  ? from_day.to_time
                    : date_and_time(from_day, from_hour)
  end

  def cal_to_time
    to_day.nil? ? cal_to_time_with_no_end_day
                : cal_to_time_with_end_day
  end

  def cal_all_day
    from_hour.nil? && to_hour.nil?
  end

  # Ce cas n'est plus possible depuis la résolution #1386
  def cal_to_time_with_no_end_day
    to_hour.nil?  ? nil # Pas de fin
                  : date_and_time(from_day, to_hour) # Heure de fin sans jour de fin, donc on se base sur le jour de début
  end

  def cal_to_time_with_end_day
    to_hour.nil?  ? cal_from_time + 1.hour # Jour de fin seul, on ajoute 1 heure pour éviter les événements sans durée
                  : date_and_time(to_day, to_hour) # Jour et heure de fin
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
