class Admin::Research::Journal::ArticlesController < Admin::Research::Journal::ApplicationController
  load_and_authorize_resource class: Research::Journal::Article, through: :journal

  include Admin::Reorderable

  def index
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @article.assign_attributes(
      journal: @journal,
      university: current_university,
      updated_by: current_user
    )
    if @article.save_and_sync
      redirect_to admin_research_journal_article_path(@article), notice: t('admin.successfully_created_html', model: @article.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @article.updated_by = current_user
    if @article.update_and_sync(article_params)
      redirect_to admin_research_journal_article_path(@article), notice: t('admin.successfully_updated_html', model: @article.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
  end
  end

  def destroy
    @article.destroy_and_sync
    redirect_to admin_research_journal_path(@journal), notice: t('admin.successfully_destroyed_html', model: @article.to_s)
  end

  private

  def breadcrumb
    super
    add_breadcrumb Research::Journal::Article.model_name.human(count: 2), admin_research_journal_articles_path
    breadcrumb_for @article
  end

  def article_params
    params.require(:research_journal_article)
          .permit(:title, :slug, :text, :published, :published_at, :abstract, :pdf, :references, :keywords, :research_journal_volume_id, researcher_ids: [])
          .merge(university_id: current_university.id)
  end
end
