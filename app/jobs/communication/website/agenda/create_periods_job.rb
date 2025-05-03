class Communication::Website::Agenda::CreatePeriodsJob < ApplicationJob
  queue_as :elephant

  def perform(event_or_time_slot)
    website = event_or_time_slot.website
    value = event_or_time_slot.from_day.year
    Communication::Website::Agenda::Period::Year.create_for(website, value)
  end
end
