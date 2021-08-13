json.array! @journals do |journal|
  json.extract! journal, :id, :title, :description
  json.url research_journal_url(journal, format: :json)
end
