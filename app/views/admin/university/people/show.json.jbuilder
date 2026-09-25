json.first_name @l10n.first_name
json.last_name @l10n.last_name
json.name @l10n.name
json.initials @l10n.initials
json.summary @l10n.summary
json.photo do
  json.thumb url_for(@person.best_picture.variant(resize_to_fill: [140, 140]))
  json.full url_for(@person.best_picture)
end if @person.best_picture.attached?