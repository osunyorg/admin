class Admin::Education::SchoolsController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::School,
                              through: :current_university,
                              through_association: :education_schools

  has_scope :for_search_term
  has_scope :for_program

  def index
    @schools = apply_scopes(@schools).ordered.page(params[:page])
    breadcrumb
  end

  def show
    @roles = @school.university_roles.ordered
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
    @school.university = current_university
    if @school.save
      redirect_to [:admin, @school], notice: t('admin.successfully_created_html', model: @school.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @school.update(school_params)
      redirect_to [:admin, @school], notice: t('admin.successfully_updated_html', model: @school.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @school.destroy
    redirect_to admin_education_schools_url, notice: t('admin.successfully_destroyed_html', model: @school.to_s)
  end

  private

  def breadcrumb
    super
    add_breadcrumb Education::School.model_name.human(count: 2), admin_education_schools_path
    breadcrumb_for @school
  end

  def school_params
    params.require(:education_school)
          .permit(:university_id, :name, :address, :zipcode, :city, :country, :phone, :logo, :logo_delete, program_ids: [])
  end
end
