class Admin::Communication::WebsitesController < Admin::Communication::Websites::ApplicationController
  include Admin::Localizable

  has_scope :for_search_term
  has_scope :for_about_type

  before_action :set_feature_nav, only: [:edit, :update]

  def index
    @websites = apply_scopes(@websites)
                  .ordered(current_language)
                  .page(params[:page])
                  .per(30)
    breadcrumb
  end

  def analytics
    breadcrumb
    add_breadcrumb t('communication.website.analytics')
  end

  def security
    breadcrumb
    add_breadcrumb t('communication.website.security')
  end

  def production
    @website.in_production = true
    breadcrumb
    add_breadcrumb t('communication.website.golive.title')
  end

  def show
    @all_pages = @website.pages.accessible_by(current_ability).tmp_original
    @pages = @all_pages.latest_in(current_language)
    @all_posts = @website.posts.accessible_by(current_ability).tmp_original
    @posts = @all_posts.latest_in(current_language)
    @all_events = @website.events.accessible_by(current_ability).tmp_original
    @events = @all_events.latest_in(current_language)
    @all_projects = @website.projects.accessible_by(current_ability).tmp_original
    @projects = @all_projects.latest_in(current_language)
    breadcrumb
  end

  def static
    @about = @website
    render layout: false, content_type: "text/plain; charset=utf-8"
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('admin.subnav.settings')
  end

  def create
    if @website.save_and_sync
      redirect_to [:admin, @website], notice: t('admin.successfully_created_html', model: @website.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @website.update_and_sync(website_params)
      redirect_to [:admin, @website], notice: t('admin.successfully_updated_html', model: @website.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @website.destroy
    redirect_to admin_communication_websites_url, notice: t('admin.successfully_destroyed_html', model: @website.to_s)
  end

  def confirm_localization
    @about_gid = params[:about]
    @about = GlobalID::Locator.locate(@about_gid)
  end

  def do_confirm_localization
    @about_gid = params[:about]
    @about = GlobalID::Locator.locate(@about_gid)
    @website.localize_in!(current_language)
    @about.localize_in!(current_language)
    redirect_to [:edit, :admin, @about]
  end

  protected

  def set_feature_nav
    @feature_nav = 'navigation/admin/communication/website/settings'
  end

  def website_params
    attribute_names = [
      :url, :repository, :about_type, :about_id, :in_production,
      :in_showcase,
      :git_provider, :git_endpoint, :git_branch, :plausible_url,
      :feature_posts, :feature_agenda, :feature_portfolio,
      :default_time_zone,
      :deuxfleurs_hosting, :default_image, :default_image_delete, :default_image_infos, :default_shared_image, :default_shared_image_delete, :default_shared_image_infos,
      :deployment_status_badge, :autoupdate_theme,
      showcase_tag_ids: [],
      localizations_attributes: [
        :id, :language_id, :name, :published,
        :social_mastodon, :social_x, :social_linkedin, :social_youtube,
        :social_vimeo, :social_peertube, :social_instagram, :social_facebook,
        :social_tiktok, :social_email, :social_github
      ]
    ]
    attribute_names << :access_token unless params[:communication_website][:access_token].blank?
    # For now, default language can't be changed, too many implications, especially around special pages.
    attribute_names << :default_language_id unless @website&.persisted?
    params.require(:communication_website)
          .permit(*attribute_names)
          .merge(
            university_id: current_university.id
          )
  end

end
