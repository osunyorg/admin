class Extranet::AcademicYearsController < Extranet::ApplicationController
  load_and_authorize_resource class: Education::AcademicYear,
                              through: :current_university,
                              through_association: :academic_years

  def index
    @academic_years = @academic_years.ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::AcademicYear.model_name.human(count: 2), education_academic_years_path
    add_breadcrumb @academic_year if @academic_year
  end
end
