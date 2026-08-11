json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-3 row-cols-2 row-cols-lg-3 row-cols-xl-4 row-cols-xxl-5'
  json.list @picker.results do |volume|
    l10n = volume.localized_in(current_language)
    json.data do
      json.id volume.id
    end
    json.snippet render(
        partial: 'admin/research/journals/volumes/volume',
        locals: { volume: volume },
        formats: [:html]
      )
  end
end