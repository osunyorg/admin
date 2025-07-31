class Communication::Website::Agenda::CheckYearJob < ApplicationJob
  queue_as :elephants

  def perform(year)
    year.destroy if year.empty?
  end
end
