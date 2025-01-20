json.extract! category,
              :id, :migration_identifier, :parent_id, :position, :is_taxonomy
json.localizations do
  category.localizations.each do |l10n|
    json.set! l10n.language.iso_code do
      json.partial! "api/osuny/university/organizations/categories/localization", l10n: l10n
    end
  end
end
json.extract! category, :created_at, :updated_at