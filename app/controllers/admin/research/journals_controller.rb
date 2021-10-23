class Admin::Research::JournalsController < Admin::Research::ApplicationController
  load_and_authorize_resource class: Research::Journal

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
    @journal.university = current_university
    if @journal.save
      redirect_to [:admin, @journal], notice: t('admin.successfully_created_html', model: @journal.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @journal.update(journal_params)
      redirect_to [:admin, @journal], notice: t('admin.successfully_updated_html', model: @journal.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @journal.destroy
    redirect_to admin_research_journals_url, notice: t('admin.successfully_destroyed_html', model: @journal.to_s)
  end

  protected

  def journal_params
    params.require(:research_journal).permit(:title, :description, :issn, :access_token, :repository)
  end
end
