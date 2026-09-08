json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-2 row-cols-1'
  json.list @picker.results do |program|
    l10n = program.localized_in(current_language)
    json.data do
      json.id program.id
    end
    json.snippet render(
        partial: 'admin/education/programs/program',
        locals: { program: program },
        formats: [:html]
      )
  end
end