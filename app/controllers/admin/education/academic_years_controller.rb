class Admin::Education::AcademicYearsController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::AcademicYear,
                              through: :current_university,
                              through_association: :academic_years

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
  end

  def create
    @academic_year.university = current_university
    if @academic_year.save
      redirect_to [:admin, @academic_year],
                  notice: t('admin.successfully_created_html', model: @academic_year.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @academic_year.update(academic_year_params)
      redirect_to [:admin, @academic_year],
                  notice: t('admin.successfully_updated_html', model: @academic_year.to_s)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @academic_year.destroy
    redirect_to education_academic_years_url,
                notice: t('admin.successfully_destroyed_html', model: @academic_year.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::AcademicYear.model_name.human(count: 2), admin_education_academic_years_path
    breadcrumb_for @academic_year
  end

  def academic_year_params
    params.require(:education_academic_year)
          .permit(:year)
  end
end
