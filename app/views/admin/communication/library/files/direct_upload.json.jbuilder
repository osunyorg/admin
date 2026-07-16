json.id @blob.id
json.signed_id @blob.signed_id
json.filename @blob.filename
json.content_type @blob.content_type
json.byte_size @blob.byte_size
json.checksum @blob.checksum
json.direct_upload do
  json.url @blob.service_url_for_direct_upload
  json.headers @blob.service_headers_for_direct_upload
end
json.file do
  json.id @file.id
  json.filename @localization.original_filename
  json.name @localization.name
end
