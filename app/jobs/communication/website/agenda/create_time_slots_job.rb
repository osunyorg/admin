class Communication::Website::Agenda::CreateTimeSlotsJob < ApplicationJob
  queue_as :elephant

  def perform
    Communication::Website::Agenda::Event.root.where.missing(:time_slots).each do |event|
      next if event.from_hour.nil?
      # TODO Create time slot
    end
  end
end