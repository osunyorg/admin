json.extract! time_slot, :id, :migration_identifier, :datetime, :duration
json.localizations do
  time_slot.localizations.each do |l10n|
    json.set! l10n.language.iso_code do
      json.partial! "api/osuny/communication/websites/agenda/events/time_slots/localization", l10n: l10n
    end
  end
end
json.extract! time_slot, :created_at, :updated_at
