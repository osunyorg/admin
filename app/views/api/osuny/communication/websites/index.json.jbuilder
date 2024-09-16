json.array! @websites.each do |website|
  json.extract! website, :id, :name, :url
end
