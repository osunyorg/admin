json.total @total
json.total_pages @total_pages
json.results @search.photos do |photo|
  json.id photo.id
  json.filename "#{photo.id}.png"
  json.credit "Photo by <a href=\"#{photo.user.url}\">#{photo.user.name}</a> on <a href=\"https://www.pexels.com\">Pexels</a>"
  json.thumb photo.src['medium']
  json.preview photo.src['large']
end
