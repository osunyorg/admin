class Admin::Communication::Websites::Portfolio::ProjectsController < Admin::Communication::Websites::Portfolio::ApplicationController
  load_and_authorize_resource class: Communication::Website::Portfolio::Project,
                              through: :website

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @projects = @projects.filter_by(params[:filters], current_language)
                         .tmp_original # TODO L10N : To remove
                         .ordered(current_language)
                         .page(params[:page])
    @feature_nav = 'navigation/admin/communication/website/portfolio'
    breadcrumb
  end

  def publish
    @l10n.publish!
    @project.sync_with_git
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
    @l10n.add_photo_import params[:photo_import]
    if @project.save_and_sync
      redirect_to admin_communication_website_portfolio_project_path(@project),
                  notice: t('admin.successfully_created_html', model: @project.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @l10n.add_photo_import params[:photo_import]
    if @project.update_and_sync(project_params)
      redirect_to admin_communication_website_portfolio_project_path(@project),
                  notice: t('admin.successfully_updated_html', model: @project.to_s_in(current_language))
    else
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
    @website.portfolio_categories
            .tmp_original # TODO L10N : Remove tmp_original
            .ordered
  end

  def project_params
    params.require(:communication_website_portfolio_project)
    .permit(
      :year,
      category_ids: [],
      localizations_attributes: [
        :id, :title, :meta_description, :summary,
        :published, :published_at, :slug,
        :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
        :shared_image, :shared_image_delete, :shared_image_infos,
        :language_id
      ]
    )
    .merge(
      university_id: current_university.id,
      language_id: current_language.id
    )
  end
end