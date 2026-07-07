class Admin::Administration::CohortsController < Admin::Administration::ApplicationController
  load_and_authorize_resource class: Administration::Cohort,
                              through: :current_university,
                              through_association: :administration_cohorts,
                              except: :restore

  include Admin::HasStaticAction
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
      }
    end
  end

  def show
    breadcrumb
  end

  def destroy
    program = @cohort.program
    label = @cohort.to_s_in(current_language)
    @cohort.destroy
    redirect_back fallback_location: admin_administration_program_cohorts_path(program),
                  notice: t('admin.successfully_destroyed_html', model: label)
  end

  def restore
    @cohort = current_university.administration_cohorts.only_deleted.find(params[:id])
    authorize!(:restore, @cohort)
    @cohort.restore(recursive: true)
    redirect_to admin_administration_cohort_path(@cohort),
                notice: t('admin.successfully_restored_html', model: @cohort.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Administration::Cohort.model_name.human(count: 2), admin_administration_cohorts_path
    breadcrumb_for @cohort
  end

  def cohort_params
    params.require(:administration_cohort)
          .permit(:program_id, :academic_year_id, :name)
  end
end
