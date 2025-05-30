json.extract! event, :id, :migration_identifier
json.from_day event.from_day
json.to_day event.to_day
json.extract! event, :time_zone, :created_by_id, :parent_id
json.localizations do
  event.localizations.each do |l10n|
    json.set! l10n.language.iso_code do
      json.partial! "api/osuny/communication/websites/agenda/events/localization", l10n: l10n
    end
  end
end
json.time_slots do
  json.partial! "api/osuny/communication/websites/agenda/events/time_slots/time_slot", collection: event.time_slots.ordered, as: :time_slot
end
json.extract! event, :category_ids
json.extract! event, :created_at, :updated_at
