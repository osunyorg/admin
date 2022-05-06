json.total = @search.total
json.results @search do |photo|
  json.partial! 'admin/communication/unsplash/photo', photo: photo
end
