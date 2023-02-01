json.total @total
json.total_pages @total_pages
json.results @search do |photo|
  json.id photo['id']
  json.filename "#{photo['id']}.jpg"
  json.alt photo['alt_description']
  json.credit "Photo by <a href=\"https://www.pexels.com/@daria\">Daria</a> on <a href=\"https://www.pexels.com\">Pexels</a>"
  json.thumb photo['urls']['small']
  json.preview photo['urls']['regular']
end
