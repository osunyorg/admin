json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-2 row-cols-1'
  json.list @picker.results do |event|
    l10n = event.localized_in(current_language)
    json.data do
      json.id event.id
    end
    json.snippet render(
        partial: 'admin/communication/websites/agenda/events/event',
        locals: { event: event },
        formats: [:html]
      )
  end
end