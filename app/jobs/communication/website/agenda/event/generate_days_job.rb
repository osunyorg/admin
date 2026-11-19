class Communication::Website::Agenda::Event::GenerateDaysJob < ApplicationJob
  queue_as :cats

  def perform(event)
    event.generate_days_safely
  end
end
