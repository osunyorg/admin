json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-2 row-cols-1'
  json.list @picker.results do |page|
    l10n = page.localized_in(current_language)
    json.data do
      json.id page.id
    end
    json.snippet render(
        partial: 'admin/communication/websites/pages/page',
        locals: { page: page },
        formats: [:html]
      )
  end
end