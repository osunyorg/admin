json.array @websites do |website|
  json.id website.id
  json.name website.original_localization.name
  json.url website.url
  json.highlighted website.highlighted_in_showcase
  json.screenshots do
    json.desktop website.screenshot.url
    json.full_page website.screenshot_full_page.url
  end
  json.instance do
    university = website.university
    json.id university.id
    json.name university.name
  end
  json.localizations website.languages do |language|
    l10n = website.localization_for(language)
    json.iso_code language.iso_code
    json.name l10n.name
  end
  json.tags website.showcase_tags do |tag| 
    json.id tag.id
    json.name tag.name
  end
end