json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'col-6 col-lg-4 col-xl-3 col-xxl-2 h-100'
  json.list @picker.results do |person|
    l10n = person.localized_in(current_language)
    json.data do
      json.id person.id
      json.name l10n.to_s
    end
    json.snippet render(
        partial: 'admin/university/people/person',
        locals: { person: person },
        formats: [:html]
      )
  end
end