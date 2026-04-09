json.extract! project, :id, :migration_identifier, :full_width, :year, :bodyclass
json.localizations do
  project.localizations.each do |l10n|
    json.set! l10n.language.iso_code do
      json.partial! "api/osuny/communication/websites/portfolio/projects/localization", l10n: l10n
    end
  end
end
json.extract! project, :category_ids
json.extract! project, :created_at, :updated_at
