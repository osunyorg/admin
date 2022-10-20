json.quantity @organizations.count
json.organizations @organizations do |organization|
  json.id organization.id
  json.title organization.to_s
  json.url organization.url
end