json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-2 row-cols-1'
  json.list @picker.results do |project|
    l10n = project.localized_in(current_language)
    json.data do
      json.id project.id
    end
    json.snippet render(
        partial: 'admin/communication/websites/portfolio/projects/project',
        locals: { project: project },
        formats: [:html]
      )
  end
end