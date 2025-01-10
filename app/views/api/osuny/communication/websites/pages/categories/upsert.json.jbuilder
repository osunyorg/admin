json.created do
  json.partial! "api/osuny/communication/websites/pages/categories/category", collection: @successfully_created_categories, as: :category
end
json.updated do
  json.partial! "api/osuny/communication/websites/pages/categories/category", collection: @successfully_updated_categories, as: :category
end
json.errors do
  json.array! @invalid_categories_with_index do |invalid_category_with_index|
    json.index invalid_category_with_index[:index]
    json.errors invalid_category_with_index[:category].errors
  end
end