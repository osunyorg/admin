class Admin::Communication::Websites::Portfolio::ProjectsController < Admin::Communication::Websites::Portfolio::ApplicationController
  load_and_authorize_resource class: Communication::Website::Portfolio::Project,
                              through: :website

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @projects = @projects.filter_by(params[:filters], current_language)
                         .ordered(current_language)
                         .page(params[:page])
    @feature_nav = 'navigation/admin/communication/website/portfolio'
    breadcrumb
  end

  def publish
    @l10n.publish!
    redirect_back fallback_location: admin_communication_website_portfolio_project_path(@project),
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
    @project.website = @website
    @project.created_by = current_user
    if @project.save
      redirect_to admin_communication_website_portfolio_project_path(@project),
                  notice: t('admin.successfully_created_html', model: @project.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      redirect_to admin_communication_website_portfolio_project_path(@project),
                  notice: t('admin.successfully_updated_html', model: @project.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    redirect_to [:admin, @project.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @project.to_s_in(current_language))
  end

  def destroy
    @project.destroy
    redirect_to admin_communication_website_portfolio_projects_url,
                notice: t('admin.successfully_destroyed_html', model: @project.to_s_in(current_language))
  end
  protected

  def breadcrumb
    super
    breadcrumb_for @project
  end

  def categories
    @website.portfolio_categories.ordered
  end

  def project_params
    params.require(:communication_website_portfolio_project)
    .permit(
      :year, :full_width, :bodyclass,
      category_ids: [],
      localizations_attributes: [
        :id, :title, :subtitle, :meta_description, :summary,
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