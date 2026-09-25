json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-2 row-cols-1'
  json.list @picker.results do |exhibition|
    l10n = exhibition.localized_in(current_language)
    json.data do
      json.id exhibition.id
    end
    json.snippet render(
        partial: 'admin/communication/websites/agenda/exhibitions/exhibition',
        locals: { exhibition: exhibition },
        formats: [:html]
      )
  end
end