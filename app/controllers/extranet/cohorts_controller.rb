class Extranet::CohortsController < Extranet::ApplicationController
  load_and_authorize_resource class: Education::Cohort,
                              through: :current_university,
                              through_association: :education_cohorts

  def index
    @facets = Education::Cohort::Facets.new params[:facets], {
      model: about.cohorts,
      about: about
    }
    @cohorts = @facets.results
                      .ordered
                      .page(params[:page])
                      .per(60)
    @count = @cohorts.total_count
    breadcrumb
  end

  def show
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::Cohort.model_name.human(count: 2), education_cohorts_path
    add_breadcrumb @cohort if @cohort
  end
end
