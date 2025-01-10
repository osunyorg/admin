json.created do
  json.partial! "api/osuny/communication/websites/pages/page", collection: @successfully_created_pages, as: :page
end
json.updated do
  json.partial! "api/osuny/communication/websites/pages/page", collection: @successfully_updated_pages, as: :page
end
json.errors do
  json.array! @invalid_pages_with_index do |invalid_page_with_index|
    json.index invalid_page_with_index[:index]
    json.errors invalid_page_with_index[:page].errors
  end
end