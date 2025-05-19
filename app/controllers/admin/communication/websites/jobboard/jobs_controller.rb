class Admin::Communication::Websites::Jobboard::JobsController < Admin::Communication::Websites::Jobboard::ApplicationController
  load_and_authorize_resource class: Communication::Website::Jobboard::Job,
                              through: :website

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @jobs = @jobs.filter_by(params[:filters], current_language)
                     .ordered_desc
                     .page(params[:page])
    @feature_nav = 'navigation/admin/communication/website/jobboard'
    breadcrumb
  end

  def publish
    @l10n.publish!
    redirect_back fallback_location: admin_communication_website_jobboard_job_path(@job),
                  notice: t('admin.communication.website.publish.notice')
  end

  def show
    breadcrumb
  end

  def new
    @categories = categories
    breadcrumb
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @job.website = @website
    @job.created_by = current_user
    if @job.save
      redirect_to admin_communication_website_jobboard_job_path(@job),
                  notice: t('admin.successfully_created_html', model: @job.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @job.update(job_params)
      redirect_to admin_communication_website_jobboard_job_path(@job),
                  notice: t('admin.successfully_updated_html', model: @job.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    redirect_to [:admin, @job.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @job.to_s_in(current_language))
  end

  def destroy
    @job.destroy
    redirect_to admin_communication_website_jobboard_jobs_url,
                notice: t('admin.successfully_destroyed_html', model: @job.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    breadcrumb_for @job
  end

  def categories
    @website.jobboard_categories.ordered
  end

  def job_params
    params.require(:communication_website_jobboard_job)
    .permit(
      :from_day, :to_day, :bodyclass,
      category_ids: [],
      localizations_attributes: [
        :id, :title, :subtitle, :meta_description, :summary, :description,
        :published, :published_at, :slug,
        :header_cta, :header_cta_label, :header_cta_url,
        :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
        :shared_image, :shared_image_delete, :shared_image_infos,
        :language_id
      ]
    )
    .merge(
      university_id: current_university.id
    )
  end
end