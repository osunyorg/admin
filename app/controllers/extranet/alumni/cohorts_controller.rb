class Extranet::Alumni::CohortsController < Extranet::Alumni::ApplicationController
  def index
    @facets = Education::Cohort::Facets.new params[:facets], {
      model: about.education_cohorts,
      about: about,
      language: current_language
    }
    @cohorts = @facets.results
                      .ordered(current_language)
                      .page(params[:page])
                      .per(60)
    @count = @cohorts.total_count
    breadcrumb
  end

  def show
    @cohort = about.education_cohorts.find(params[:id])
    breadcrumb
    add_breadcrumb @cohort
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::Cohort.model_name.human(count: 2), alumni_education_cohorts_path
  end
end
