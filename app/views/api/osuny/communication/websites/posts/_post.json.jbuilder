json.extract! post, :id, :migration_identifier, :full_width
json.localizations do
  post.localizations.each do |l10n|
    json.set! l10n.language.iso_code do
      json.partial! "api/osuny/communication/websites/posts/localization", l10n: l10n
    end
  end
end
json.extract! post, :created_at, :updated_at
