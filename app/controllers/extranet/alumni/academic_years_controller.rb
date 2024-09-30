class Extranet::Alumni::AcademicYearsController < Extranet::Alumni::ApplicationController
  def index
    @academic_years = about&.education_academic_years
                            .ordered(current_language)
                            .page(params[:page])
    @count = @academic_years.total_count
    breadcrumb
  end

  def show
    @academic_year = about.education_academic_years.find(params[:id])
    @cohorts = @academic_year.cohorts_in_context(current_context.about)
    @alumni = @academic_year.alumni_in_context(current_context.about)
    breadcrumb
    add_breadcrumb @academic_year
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::AcademicYear.model_name.human(count: 2), alumni_education_academic_years_path
  end
end
