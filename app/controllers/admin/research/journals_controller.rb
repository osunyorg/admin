class Admin::Research::JournalsController < Admin::Research::ApplicationController
  load_and_authorize_resource class: Research::Journal,
                              through: :current_university,
                              through_association: :research_journals

  def index
    @journals = @journals.ordered.page(params[:page])
    breadcrumb
    add_breadcrumb Research::Journal.model_name.human(count: 2), admin_research_journals_path
  end

  def show
    @articles = @journal.articles.order(published_at: :desc, created_at: :desc).limit(10)
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
    if @journal.save_and_sync
      redirect_to [:admin, @journal], notice: t('admin.successfully_created_html', model: @journal.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @journal.update_and_sync(journal_params)
      redirect_to [:admin, @journal], notice: t('admin.successfully_updated_html', model: @journal.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @journal.destroy_and_sync
    redirect_to admin_research_journals_url, notice: t('admin.successfully_destroyed_html', model: @journal.to_s)
  end

  protected

  def journal_params
    params.require(:research_journal)
          .permit(:title, :description, :issn, :access_token, :repository)
          .merge(university_id: current_university.id)
  end
end
