json.extract! @article, :id, :title, :text, :published_at
if @article.volume
  json.volume do
    json.extract! @article.volume, :id, :title, :number, :published_at
    json.url research_journal_volume_url(journal: @volume.journal, id: @volume, format: :json)

  end
end
