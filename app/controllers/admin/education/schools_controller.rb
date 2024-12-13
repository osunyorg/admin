class Admin::Education::SchoolsController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::School,
                              through: :current_university,
                              through_association: :education_schools

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @schools = @schools.filter_by(params[:filters], current_language)
                       .ordered(current_language)
                       .page(params[:page])
    breadcrumb
  end

  def show
    @programs = @school.programs.ordered(current_language)
    @roles = @school.university_roles.ordered(current_language)
    @websites = @school.websites.ordered(current_language)
    @locations = @school.locations.ordered(current_language)
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
    if @school.save
      redirect_to [:admin, @school], notice: t('admin.successfully_created_html', model: @school.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @school.update(school_params)
      redirect_to [:admin, @school], notice: t('admin.successfully_updated_html', model: @school.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @school.destroy
    redirect_to admin_education_schools_url, notice: t('admin.successfully_destroyed_html', model: @school.to_s_in(current_language))
  end

  private

  def breadcrumb
    super
    add_breadcrumb Education::School.model_name.human(count: 2), admin_education_schools_path
    breadcrumb_for @school
  end

  def school_params
    params.require(:education_school)
          .permit(
            :address, :zipcode, :city, :country, :phone,
            program_ids: [],
            localizations_attributes: [
              :id, :language_id,
              :name, :url,
              :logo, :logo_delete,
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end
end
