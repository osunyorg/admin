json.array! @articles do |article|
  json.extract! article, :id, :title, :text, :published_at
  json.url research_journal_article_url(journal_id: article.journal, id: article, format: :json)
end
