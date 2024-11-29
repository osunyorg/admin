json.array! @websites.each do |website|
  json.id website.id
  json.name website.to_s_in(current_language)
  json.url website.url
end
