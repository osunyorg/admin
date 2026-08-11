json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-3 row-cols-2 row-cols-lg-3 row-cols-xl-4 row-cols-xxl-5'
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