class Admin::Communication::WebsitesController < Admin::Communication::Websites::ApplicationController
  has_scope :for_search_term
  has_scope :for_about_type

  def index
    @websites = apply_scopes(@websites).ordered.page(params[:page])
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

  def show
    @all_pages = @website.pages.accessible_by(current_ability).for_language(current_website_language)
    @pages = @all_pages.recent
    @all_posts = @website.posts.accessible_by(current_ability).for_language(current_website_language)
    @posts = @all_posts.recent
    @all_events = @website.events.accessible_by(current_ability).for_language(current_website_language)
    @events = @all_events.recent
    breadcrumb
  end

  def static
    @about = @website
    render layout: false
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @website.university = current_university
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

  protected

  def website_params
    attribute_names = [
      :name, :url, :repository, :about_type, :about_id, :in_production,
      :git_provider, :git_endpoint, :git_branch, :plausible_url, 
      :feature_posts, :feature_agenda,
      :deuxfleurs_hosting,
      :social_mastodon, :social_x, :social_linkedin, :social_youtube, :social_vimeo, :social_peertube, :social_instagram, :social_facebook, :social_tiktok, :social_email, :social_github,
      :deployment_status_badge, :autoupdate_theme, language_ids: []
    ]
    attribute_names << :access_token unless params[:communication_website][:access_token].blank?
    # For now, default language can't be changed, too many implications, especially around special pages.
    attribute_names << :default_language_id unless @website&.persisted?
    params.require(:communication_website).permit(*attribute_names)
  end

  def default_url_options
    options = {}
    options[:lang] = current_website_language.iso_code if @website&.persisted?
    options
  end
end
