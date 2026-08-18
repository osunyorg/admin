json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-3 row-cols-2 row-cols-lg-3 row-cols-xl-4 row-cols-xxl-5'
  json.list @picker.results do |media|
    l10n = media.localized_in(current_language)
    json.data do
      json.id media.id
      json.alt l10n.alt
    end
    json.snippet render(
        partial: 'admin/communication/library/medias/media',
        locals: { media: media },
        formats: [:html]
      )
  end
end