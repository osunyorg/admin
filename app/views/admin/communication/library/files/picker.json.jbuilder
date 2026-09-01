json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-2 row-cols-1'
  json.list @picker.results do |file|
    l10n = file.localized_in(current_language)
    json.data do
      json.id file.id
    end
    json.snippet render(
        partial: 'admin/communication/library/files/file',
        locals: {
          file: file,
          hide_date: @picker.current_sort != 'date_desc' && @picker.current_sort != 'date_asc',
          hide_size: @picker.current_sort != 'size_desc' && @picker.current_sort != 'size_asc'
        },
        formats: [:html]
      )
  end
end