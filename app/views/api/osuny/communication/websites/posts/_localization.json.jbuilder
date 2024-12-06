json.extract! l10n, :id, :migration_identifier, :title
if l10n.featured_image.attached?
  json.extract! l10n, :featured_image_alt, :featured_image_credit
end
json.extract! l10n, :meta_description, :pinned, :published, :published_at,
                    :slug, :subtitle, :summary, :text, :created_at, :updated_at