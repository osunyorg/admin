json.extract! journal, :id, :title, :description, :created_at, :updated_at
json.url research_journal_url(journal, format: :json)
