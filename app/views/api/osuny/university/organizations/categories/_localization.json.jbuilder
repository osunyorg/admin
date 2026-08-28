json.extract! l10n, :id, :migration_identifier, :name, :breadcrumb_title, :featured_media_id
json.featured_image do
  json.blob_id l10n.featured_blob&.id
  json.alt l10n.featured_media_alt
  json.credit l10n.featured_media_credit
  json.url l10n.featured_blob&.url
end
json.extract! l10n, :header_cta, :header_cta_label, :header_cta_url, :header_text, :meta_description, :slug, :summary
json.blocks do
  json.partial! "api/osuny/communication/blocks/block", collection: l10n.blocks.ordered, as: :block
end
json.extract! l10n, :created_at, :updated_at
