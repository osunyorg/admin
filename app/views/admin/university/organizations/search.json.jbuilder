json.array! @organizations do |organization|
  json.id organization.id
  json.label organization.to_s
  json.value organization.to_s
end