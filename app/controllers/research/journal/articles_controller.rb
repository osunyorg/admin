class Research::Journal::ArticlesController < ApplicationController
  def index
    @journal = current_university.research_journals.find params[:journal_id]
    @articles = @journal.articles
    breadcrumb
  end

  def show
    @journal = current_university.research_journals.find params[:journal_id]
    @article = @journal.articles.find params[:id]
    @volume = @article.volume
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research.model_name.human
    add_breadcrumb Research::Journal.model_name.human(count: 2), research_journals_path
    add_breadcrumb @journal, @journal
    if @article
      if @volume
        add_breadcrumb @volume, research_journal_volume_path(journal_id: @journal.id, id: @volume.id)
      else
        add_breadcrumb Research::Journal::Article.model_name.human(count: 2), research_journal_articles_path(journal_id: @journal)
      end
      add_breadcrumb @article
    else
      add_breadcrumb Research::Journal::Article.model_name.human(count: 2)
    end
  end
end
