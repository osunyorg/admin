json.extract! event, :id, :migration_identifier
json.from_day event.from_day
json.from_hour event.from_hour.strftime("%H:%M")
json.to_day event.to_day
json.to_hour event.to_hour.strftime("%H:%M")
json.extract! event, :time_zone, :created_by_id, :parent_id
json.localizations do
  event.localizations.each do |l10n|
    json.set! l10n.language.iso_code do
      json.partial! "api/osuny/communication/websites/agenda/events/localization", l10n: l10n
    end
  end
end
json.extract! event, :created_at, :updated_at
