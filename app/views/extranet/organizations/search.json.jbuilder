json.array! @organizations do |organization|
  json.id organization.id
  json.label organization.to_s_in(current_language)
  json.value organization.to_s_in(current_language)
end