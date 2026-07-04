json.total @files.total_count
json.total_pages @files.total_pages
json.collections @collections do |collection|
  json.id collection.id
  json.name collection.to_s_in(current_language)
end

json.partial! 'admin/application/categories/list', categories: @categories

json.results @files do |file|
  next unless file.original_blob.variable?
  thumb_path = ENV["KEYCDN_HOST"].present?  ? file.keycdn_thumb_url
                                            : url_for(file.original_blob.variant(resize_to_fit: [600, nil]))
  l10n = file.best_localization_for(current_language)
  json.id file.id
  json.name l10n.name
  json.credit l10n.credit.to_s
  json.alt l10n.alt.to_s
  json.thumb thumb_path
end
