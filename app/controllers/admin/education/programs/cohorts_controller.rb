class Admin::Education::Programs::CohortsController < Admin::Education::Programs::ApplicationController
  load_and_authorize_resource class: Education::Cohort, through: :program, through_association: :education_cohorts

  include Admin::Localizable

  def index
    @filtered = @cohorts.filter_by(params[:filters], current_language)
    @cohorts = @filtered.at_lifecycle(params[:lifecycle], current_language)
                        .ordered

    respond_to do |format|
      format.html {
        @cohorts = @cohorts.page(params[:page])
        breadcrumb
      }
      format.xlsx {
        filename = "cohorts-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
        render "admin/education/cohorts/index"
      }
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::Cohort.model_name.human(count: 2)
  end

end
