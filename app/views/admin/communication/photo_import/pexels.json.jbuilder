json.total @total
json.total_pages @total_pages
json.results @search do |photo|
  json.partial! 'admin/communication/photo_import/unsplash/photo', photo: photo
end
