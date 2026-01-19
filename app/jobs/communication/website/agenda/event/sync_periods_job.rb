class Communication::Website::Agenda::Event::SyncPeriodsJob < ApplicationJob
  queue_as :elephants

  def perform(event)
    event.sync_periods_safely
  end
end
