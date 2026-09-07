json.total @total
json.total_pages @total_pages
if @search.is_a?(Pexels::PhotoSet)
  json.results @search.photos do |photo|
    json.id photo.id
    json.credit "Photo by <a href=\"#{photo.user.url}\">#{photo.user.name}</a> on <a href=\"https://www.pexels.com\">Pexels</a>"
    json.thumb photo.src['large']
    json.source "#{photo.src['original']}?auto=compress&cs=tinysrgb&w=2048"
  end
else
  json.results []
end
