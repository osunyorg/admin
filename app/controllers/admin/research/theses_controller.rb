class Admin::Research::ThesesController < Admin::Research::ApplicationController
  load_and_authorize_resource class: Research::Thesis,
                              through: :current_university,
                              through_association: :research_theses

  def index
    @theses = @theses.ordered.page(params[:page])
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
    if @thesis.save
      redirect_to [:admin, @thesis], notice: t('admin.successfully_created_html', model: @thesis.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @thesis.update(thesis_params)
      redirect_to [:admin, @thesis], notice: t('admin.successfully_updated_html', model: @thesis.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @thesis.destroy
    redirect_to admin_research_theses_url, notice: t('admin.successfully_destroyed_html', model: @thesis.to_s)
  end

  protected

  def thesis_params
    params.require(:research_thesis).permit(
      :title, :abstract, :started_at, :completed, :completed_at,
      :research_laboratory_id, :author_id, :director_id
    ).merge(university_id: current_university.id)
  end

  def breadcrumb
    super
    add_breadcrumb Research::Thesis.model_name.human(count: 2), admin_research_theses_path
    breadcrumb_for @thesis
  end
end
