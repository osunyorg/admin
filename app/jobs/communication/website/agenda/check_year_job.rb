class Communication::Website::Agenda::CheckYearJob < ApplicationJob
  queue_as :elephant

  def perform(website, date)
    day = Communication::Website::Agenda::Period::Day.find_by(
      university: website.university,
      website: website,
      date: date
    )
    day.denormalize_localizations_events_count if day.present?
    year = Communication::Website::Agenda::Period::Year.find_by(
      university: website.university,
      website: website,
      value: date.year
    )
    year.destroy_if_empty if year.present?
  end
end
