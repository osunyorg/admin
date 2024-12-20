json.extract! event,
              :id, :migration_identifier, :from_day, :from_hour, :to_day, :to_hour,
              :time_zone, :created_by_id, :parent_id
json.localizations do
  event.localizations.each do |l10n|
    json.set! l10n.language.iso_code do
      json.partial! "api/osuny/communication/websites/agenda/events/localization", l10n: l10n
    end
  end
end
json.extract! event, :created_at, :updated_at
