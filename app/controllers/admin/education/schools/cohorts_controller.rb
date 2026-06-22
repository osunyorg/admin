class Admin::Education::Schools::CohortsController < Admin::Education::Schools::ApplicationController
  load_and_authorize_resource class: Education::Cohort, through: :school, through_association: :education_cohorts

  include Admin::Localizable

  def index
    @filtered = @cohorts.filter_by(params[:filters], current_language)
    @cohorts = @filtered.at_lifecycle(params[:lifecycle], current_language)
                        .ordered
                        .page(params[:page])
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::Cohort.model_name.human(count: 2)
  end

end
