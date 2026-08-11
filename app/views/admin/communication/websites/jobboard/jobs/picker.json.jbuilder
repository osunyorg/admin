json.parameters @picker.parameters
json.pagination @picker.pagination
json.results do
  json.classes 'row g-3 row-cols-2 row-cols-lg-3 row-cols-xl-4 row-cols-xxl-5'
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