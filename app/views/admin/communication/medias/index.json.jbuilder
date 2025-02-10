json.total @medias.total_count
json.total_pages @medias.total_pages
json.collections @collections do |collection|
  json.id collection.id
  json.name collection.to_s_in(current_language)
end

json.partial! 'admin/application/categories/list', categories: @categories

json.results @medias do |media|
  next unless media.original_blob.variable?
  thumb_path = url_for(media.original_blob.variant(resize: "600x"))
  l10n = media.best_localization_for(current_language)
  json.id media.id
  json.name l10n.name
  json.credit l10n.credit.to_s
  json.alt l10n.alt.to_s
  json.thumb thumb_path
end
