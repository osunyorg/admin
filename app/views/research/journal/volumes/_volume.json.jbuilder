json.extract! volume, :id, :title, :number, :published_at, :created_at, :updated_at
json.url research_journal_volume_url(journal: volume.journal, id: volume, format: :json)
