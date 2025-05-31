class Extranet::Alumni::CohortsController < Extranet::Alumni::ApplicationController
  def index
    @facets = Education::Cohort::Facets.new params[:facets], {
      model: current_extranet.about.education_cohorts,
      about: current_extranet.about,
      language: current_language
    }
    @cohorts = @facets.results
                      .ordered(current_language)
                      .page(params[:page])
                      .per(72)
    @count = @cohorts.total_count
    breadcrumb
  end

  def show
    @cohort = current_extranet.about.education_cohorts
                                    .find(params[:id])
    @l10n = @cohort.best_localization_for(current_language)
    @people =  @cohort.people
                      .ordered(current_language)
                      .page(params[:page])
                      .per(72)
    breadcrumb
    add_breadcrumb @l10n
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::Cohort.model_name.human(count: 2), alumni_education_cohorts_path
  end
end
