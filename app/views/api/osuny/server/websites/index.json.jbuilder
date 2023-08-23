json.array! @websites.each do |website|
  json.name website.name
  json.url website.url
end
