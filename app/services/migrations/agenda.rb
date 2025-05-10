class Migrations::Agenda
  def self.migrate
    Communication::Website::Agenda::Event::TimeSlot.find_each do |time_slot|
      event = time_slot.event
      event.localizations.each do |event_l10n|
        time_slot_l10n = time_slot.localizations.where(
          university: event.university,
          website: event.website,
          language: event_l10n.language
        ).first_or_create
      end
    end
  end
end