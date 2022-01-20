class Admin::Research::Laboratory::AxesController < Admin::Research::Laboratory::ApplicationController
  load_and_authorize_resource class: Research::Laboratory::Axis, through: :laboratory

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
    @axis.laboratory = @laboratory
    if @axis.save
      redirect_to admin_research_laboratory_axis_path(@axis), notice: t('admin.successfully_created_html', model: @axis.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @axis.update(axis_params)
      redirect_to admin_research_laboratory_axis_path(@axis), notice: t('admin.successfully_updated_html', model: @axis.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
  end
  end

  def destroy
    @axis.destroy
    redirect_to admin_research_laboratory_path(@laboratory), notice: t('admin.successfully_destroyed_html', model: @axis.to_s)
  end

  private

  def breadcrumb
    super
    add_breadcrumb Research::Laboratory::Axis.model_name.human(count: 2), admin_research_laboratory_axes_path
    breadcrumb_for @axis
  end

  def axis_params
    params.require(:research_laboratory_axis)
          .permit(:name, :description, :text)
          .merge(university_id: current_university.id)
  end
end
