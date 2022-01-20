class Admin::Research::LaboratoriesController < Admin::Research::ApplicationController
  load_and_authorize_resource class: Research::Laboratory,
                              through: :current_university,
                              through_association: :research_laboratories

  def index
    @laboratories = @laboratories.ordered.page(params[:page])
    breadcrumb
    add_breadcrumb Research::Laboratory.model_name.human(count: 2), admin_research_laboratories_path
  end

  def show
    @axes = @laboratory.axes.ordered
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
    if @laboratory.save_and_sync
      redirect_to [:admin, @laboratory], notice: t('admin.successfully_created_html', model: @laboratory.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @laboratory.update_and_sync(laboratory_params)
      redirect_to [:admin, @laboratory], notice: t('admin.successfully_updated_html', model: @laboratory.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @laboratory.destroy_and_sync
    redirect_to admin_research_laboratories_url, notice: t('admin.successfully_destroyed_html', model: @laboratory.to_s)
  end

  protected

  def laboratory_params
    params.require(:research_laboratory)
          .permit(:name, :address, :zipcode, :city, :country)
          .merge(university_id: current_university.id)
  end
end
