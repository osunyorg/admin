class Admin::Research::Laboratories::AxesController < Admin::Research::Laboratories::ApplicationController
  load_and_authorize_resource class: Research::Laboratory::Axis, through: :laboratory

  include Admin::Reorderable
  include Admin::Localizable

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
      redirect_to admin_research_laboratory_axis_path(@axis), 
                  notice: t('admin.successfully_created_html', model: @axis.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @axis.update(axis_params)
      redirect_to admin_research_laboratory_axis_path(@axis), 
                  notice: t('admin.successfully_updated_html', model: @axis.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @axis.destroy
    redirect_to admin_research_laboratory_path(@laboratory), 
                notice: t('admin.successfully_destroyed_html', model: @axis.to_s_in(current_language))
  end

  private

  # For Admin::Reorderable
  def model
    Research::Laboratory::Axis
  end

  def breadcrumb
    super
    add_breadcrumb Research::Laboratory::Axis.model_name.human(count: 2), admin_research_laboratory_axes_path
    breadcrumb_for @axis
  end

  def axis_params
    params.require(:research_laboratory_axis)
          .permit(
            localizations_attributes: [
              :id, :language_id,
              :name, :short_name, :meta_description, :summary
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end
end
