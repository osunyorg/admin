json.total @medias.total_count
json.total_pages @medias.total_pages
json.results @medias do |media|
  l10n = media.best_localization_for(current_language)
  json.id media.id
  json.name l10n.name
  json.credit l10n.credit
  json.alt l10n.alt
  json.thumb media.original_blob.variant(resize: "600x").url
end
