json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.list @picker.results do |file|
    l10n = file.localized_in(current_language)
    json.data do
      json.communication_file_id file.id
      json.filename l10n.original_filename
      json.name l10n.name
    end
    json.snippet render(
        partial: 'admin/communication/library/files/file',
        locals: { file: file },
        formats: [:html]
      )
  end
end