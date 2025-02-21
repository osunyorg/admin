class Communication::Website::Agenda::CreateTimeSlotsJob < ApplicationJob
  queue_as :elephant

  def perform
    Communication::Website::Agenda::Event.root.where.missing(:time_slots).each do |event|
      # No time, we skip
      next if event.from_hour.nil?
      if event.to_day.nil? || event.to_day == event.from_day
        # One-day event
        create_time_slot(event, event.from_day)
      else
        # Multi-days event, we need to add a timeslot for each day
        (event.to_day..event.from_day).each do |day|
          create_time_slot(event, day)
        end
      end
    end
  end

  protected

  def create_time_slot(event, day)
    datetime = DateTime.new day.year,
                            day.month,
                            day.day,
                            event.from_hour.hour,
                            event.from_hour.min

    duration = event.to_hour.present? ? event.to_hour - event.from_hour : 0
    event.time_slots.create(
      datetime: datetime,
      duration: duration,
      communication_website_id: event.communication_website_id,
      university_id: event.university_id
    )
  end
end