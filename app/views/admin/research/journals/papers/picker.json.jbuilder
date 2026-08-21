json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-2 row-cols-1'
  json.list @picker.results do |paper|
    l10n = paper.localized_in(current_language)
    json.data do
      json.id paper.id
    end
    json.snippet render(
        partial: 'admin/research/journals/papers/paper',
        locals: { paper: paper },
        formats: [:html]
      )
  end
end