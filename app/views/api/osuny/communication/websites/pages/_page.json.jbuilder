json.extract! page,
              :id, :migration_identifier, :type,
              :parent_id, :position, :bodyclass, :full_width
json.localizations do
  page.localizations.each do |l10n|
    json.set! l10n.language.iso_code do
      json.partial! "api/osuny/communication/websites/pages/localization", l10n: l10n
    end
  end
end
json.extract! page, :created_at, :updated_at
