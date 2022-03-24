class Admin::Education::CohortsController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::Cohort,
                              through: :current_university,
                              through_association: :education_cohorts

  def index
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
  end

  def create
    @cohort.university = current_university
    if @cohort.save
      redirect_to [:admin, @cohort],
                  notice: t('admin.successfully_created_html', model: @cohort.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @cohort.update(cohort_params)
      redirect_to [:admin, @cohort],
                  notice: t('admin.successfully_updated_html', model: @cohort.to_s)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cohort.destroy
    redirect_to education_cohorts_url,
                notice: t('admin.successfully_destroyed_html', model: @cohort.to_s)
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
