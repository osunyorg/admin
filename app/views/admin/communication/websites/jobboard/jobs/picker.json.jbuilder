json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-2 row-cols-1'
  json.list @picker.results do |job|
    l10n = job.localized_in(current_language)
    json.data do
      json.id job.id
    end
    json.snippet render(
        partial: 'admin/communication/websites/jobboard/jobs/job',
        locals: { job: job },
        formats: [:html]
      )
  end
end