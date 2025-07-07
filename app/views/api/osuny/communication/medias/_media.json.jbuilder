json.extract! media,
              :id, :origin,
              :original_byte_size, :original_checksum,
              :original_content_type, :original_filename,
              :communication_media_collection_id
json.localizations do
  media.localizations.each do |l10n|
    json.set! l10n.language.iso_code do
      json.partial! "api/osuny/communication/medias/localization", l10n: l10n
    end
  end
end
json.original_blob do
  json.extract! media.original_blob,
                :id, :signed_id, :filename, :content_type
end
json.extract! media, :communication_media_collection_id
json.extract! media, :created_at, :updated_at
