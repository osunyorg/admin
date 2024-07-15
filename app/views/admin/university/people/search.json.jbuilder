json.array! @people do |person|
  json.id person.id
  # TODO L10N : To adjust
  json.label person.to_s_with_mail
  json.value person.to_s_with_mail
end