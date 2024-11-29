json.array! @websites.each do |website|
  json.extract! website, :id, :url
  json.localizations website.localizations do |l10n|
    json.extract! l10n, :id, :name
    json.language l10n.language.iso_code
    json.extract! l10n, :published, :published_at, :created_at, :updated_at
  end
end
