json.parameters @picker.parameters
json.results @picker.paginated_objects do |file|
  l10n = file.localized_in(current_language)
  json.id file.id
  json.name l10n.name
  json.icon l10n.icon
  json.snippet render(
      partial: 'admin/communication/library/files/file',
      locals: { file: file },
      formats: [:html]
    )
end