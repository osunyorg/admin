json.extract! l10n, :id, :migration_identifier, :name, :long_name, :published, :published_at
json.featured_image do
  json.blob_id l10n.featured_image.blob_id
  json.alt l10n.featured_image_alt
  json.credit l10n.featured_image_credit
  json.url l10n.featured_image.url
end
json.extract! l10n, :meta_description, :address_name, :address_additional,
                    :linkedin, :mastodon, :twitter, :url,
                    :slug, :summary, :text
json.blocks do
  json.partial! "api/osuny/communication/blocks/block", collection: l10n.blocks.ordered, as: :block
end
json.extract! l10n, :created_at, :updated_at
