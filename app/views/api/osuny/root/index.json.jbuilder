json.communication do 
  json.websites @websites.each do |website|
    json.name website.name
    json.url website.url
  end
end
