class Admin::Research::LaboratoriesController < Admin::Research::ApplicationController
  load_and_authorize_resource class: Research::Laboratory,
                              through: :current_university,
                              through_association: :research_laboratories

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @laboratories = @laboratories.filter_by(params[:filters], current_language)
                                 .ordered(current_language)
                                 .page(params[:page])
    breadcrumb
  end

  def show
    @axes = @laboratory.axes.ordered
    breadcrumb
  end

  def static
    @about = @laboratory
    render_as_plain_text
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @laboratory.save
      redirect_to [:admin, @laboratory], notice: t('admin.successfully_created_html', model: @laboratory.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @laboratory.update(laboratory_params)
      redirect_to [:admin, @laboratory], notice: t('admin.successfully_updated_html', model: @laboratory.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @laboratory.destroy
    redirect_to admin_research_laboratories_url, notice: t('admin.successfully_destroyed_html', model: @laboratory.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research::Laboratory.model_name.human(count: 2), admin_research_laboratories_path
    breadcrumb_for @laboratory
  end

  def laboratory_params
    params.require(:research_laboratory)
          .permit(
            :address, :zipcode, :city, :country,
            localizations_attributes: [
              :id, :language_id,
              :name, :address_name, :address_additional
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end
end
