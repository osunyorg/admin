json.array! @websites.each do |website|
  json.id website.id
  json.url website.url

  localizations = website.localizations
  json.localizations localizations do |l10n|
    json.extract! l10n, :id, :name
    json.language l10n.language.iso_code
    json.extract! l10n, :published, :published_at
  end
end
