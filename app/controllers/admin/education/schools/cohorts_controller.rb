class Admin::Education::Schools::CohortsController < Admin::Education::Schools::ApplicationController
  load_and_authorize_resource class: Administration::Cohort, through: :school, through_association: :administration_cohorts

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
        render "admin/administration/cohorts/index"
      }
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Administration::Cohort.model_name.human(count: 2)
  end

end
