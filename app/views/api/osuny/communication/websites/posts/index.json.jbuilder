json.array! @posts.each do |post|
  json.id post.id
  json.migration_identifier post.migration_identifier
  json.localizations post.localizations do |l10n|
    json.extract! l10n, :id, :title
    json.language l10n.language.iso_code
    json.extract! l10n, :published, :published_at, :created_at, :updated_at
  end
  json.created_at post.created_at
  json.updated_at post.updated_at
end
