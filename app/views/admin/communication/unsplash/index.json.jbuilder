json.total = @search.total
json.total_pages = @search.total_pages
json.results @search do |photo|
  json.partial! 'admin/communication/unsplash/photo', photo: photo
end
