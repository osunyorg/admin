json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-3 row-cols-2 row-cols-lg-3 row-cols-xl-4 row-cols-xxl-5'
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