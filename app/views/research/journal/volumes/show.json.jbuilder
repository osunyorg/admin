json.extract! @volume, :id, :title, :number, :published_at
json.url research_journal_volume_url(journal: @volume.journal, id: @volume, format: :json)
json.articles @volume.articles do |article|
  json.extract! article, :id, :title, :published_at
  json.url research_journal_article_url(journal_id: article.journal, id: article, format: :json)
end
