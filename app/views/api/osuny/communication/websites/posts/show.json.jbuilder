json.extract! @post, :id, :migration_identifier, :full_width
json.localizations @post.localizations do |l10n|
  json.extract! l10n, :id, :migration_identifier, :title
  json.language l10n.language.iso_code

  json.featured_image do
    json.blob_id l10n.featured_image.blob_id
    json.alt l10n.featured_image_alt
    json.credit l10n.featured_image_credit
  end if l10n.featured_image.attached?

  json.extract! l10n, :meta_description, :pinned, :published, :published_at,
                      :slug, :subtitle, :summary, :text, :created_at, :updated_at
end
json.website_id @post.communication_website_id
json.extract! @post, :created_at, :updated_at