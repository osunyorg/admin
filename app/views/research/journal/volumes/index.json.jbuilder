json.array! @volumes do |volume|
  json.extract! volume, :id, :title, :number, :published_at
  json.url research_journal_volume_url(journal_id: volume.journal, id: volume, format: :json)
end
