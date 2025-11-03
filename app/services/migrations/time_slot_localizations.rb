class Migrations::TimeSlotLocalizations
  def self.migrate
    # Events with multiple localizations
    event_ids = Communication::Website::Agenda::Event::Localization
              .group(:about_id)
              .having("COUNT(language_id) > 1")
              .count
              .keys

    # Time slots for these events with multiple localizations
    time_slots = Communication::Website::Agenda::Event::TimeSlot
                  .includes(communication_website_agenda_event: :localizations)
                  .where(communication_website_agenda_event_id: event_ids)

    time_slots.find_each do |time_slot|
      # Get first l10n in case we need to localize the time_slot
      first_time_slot_l10n = time_slot.localizations.first
      time_slot.event.localizations.each do |event_l10n|
        # Try to find time slot l10n for this language
        time_slot_l10n = time_slot.localizations.find_by(language_id: event_l10n.language_id)
        # Else we localize the original time slot l10n
        if time_slot_l10n.nil?
          first_time_slot_l10n.localize_in!(event_l10n.language)
          puts "Localized TimeSlot ##{time_slot.id} in #{event_l10n.language.iso_code}"
        end
      end
    end
  end
end
