class Admin::Education::CohortsController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::Cohort,
                              through: :current_university,
                              through_association: :education_cohorts,
                              except: :restore

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @filtered = @cohorts
    @cohorts =  @cohorts.at_lifecycle(params[:lifecycle], current_language)
                        .ordered
    breadcrumb
  end

  def show
    breadcrumb
  end

  def destroy
    program = @cohort.program
    label = @cohort.to_s_in(current_language)
    @cohort.destroy
    redirect_to alumni_admin_education_program_path(program),
                notice: t('admin.successfully_destroyed_html', model: label)
  end

  def restore
    @cohort = current_university.education_cohorts.only_deleted.find(params[:id])
    authorize!(:restore, @cohort)
    @cohort.restore(recursive: true)
    redirect_to admin_education_cohort_path(@cohort),
                notice: t('admin.successfully_restored_html', model: @cohort.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::Cohort.model_name.human(count: 2), admin_education_cohorts_path
    breadcrumb_for @cohort
  end

  def cohort_params
    params.require(:education_cohort)
          .permit(:program_id, :academic_year_id, :name)
  end
end
