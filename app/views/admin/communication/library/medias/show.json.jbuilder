json.id @media.id
json.name @l10n.name.to_s
json.alt @l10n.alt.to_s
json.published @l10n.published
json.path admin_communication_media_path(@media)
json.media do
  json.thumb @media.thumb_url
  json.url @media.original_blob.url
end
json.context do
  json.thumb @context.thumb_url
  json.url @context.blob.url
  json.crop_settings @context.crop_settings
end if @context