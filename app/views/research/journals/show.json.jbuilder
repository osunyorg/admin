json.extract! @journal, :id, :title, :description
json.url research_journal_url(@journal, format: :json)
json.volumes @journal.volumes do |volume|
  json.extract! volume, :id, :title, :published_at
  json.url research_journal_volume_url(journal_id: @journal, id: volume, format: :json)
end
