json.array! @photos do |photo|
  json.partial! 'admin/communication/unsplash/photo', photo: photo
end
