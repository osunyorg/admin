json.array! @people do |person|
  json.id person.id
  # TODO L10N : To adjust
  json.label person.to_s_with_mail_in(current_language)
  json.value person.to_s_with_mail_in(current_language)
end