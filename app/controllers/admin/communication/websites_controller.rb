class Admin::Communication::WebsitesController < Admin::Communication::Websites::ApplicationController
  include Admin::Localizable

  before_action :set_feature_nav, only: [:edit, :edit_language, :edit_federation, :edit_technical, :update]

  def index
    @websites = @websites.filter_by(params[:filters], current_language)
                         .ordered(current_language)
                         .page(params[:page])
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
    # Objects
    @pages        = @website.pages
                            .accessible_by(current_ability)
                            .latest_in(current_language)
    @posts        = @website.posts
                            .accessible_by(current_ability)
                            .latest_in(current_language)
    @events       = @website.events
                            .root
                            .accessible_by(current_ability)
                            .latest_in(current_language)
    @exhibitions  = @website.exhibitions
                            .accessible_by(current_ability)
                            .latest_in(current_language)
    @projects     = @website.projects
                            .accessible_by(current_ability)
                            .latest_in(current_language)
    @jobs         = @website.jobs
                            .accessible_by(current_ability)
                            .latest_in(current_language)
    # Parts
    @show_posts       = @website.feature_posts &&
                          @posts.any? &&
                          can?(:read, Communication::Website::Post)
    @show_events      = @website.feature_agenda &&
                          @events.any? && 
                          can?(:read, Communication::Website::Agenda::Event)
    @show_exhibitions = @website.feature_agenda &&
                          @exhibitions.any? &&
                          can?(:read, Communication::Website::Agenda::Exhibition)
    @show_projects    = @website.feature_portfolio && 
                          @projects.any? &&
                          can?(:read, Communication::Website::Portfolio::Project)
    @show_jobs        = @website.feature_jobboard &&
                          @jobs.any? &&
                          can?(:read, Communication::Website::Jobboard::Job)
    # Git files
    @git_files_desynchronized = @website.git_files_desynchronized
    breadcrumb
  end

  def synchronize
    @website.sync_with_git
    redirect_to admin_communication_website_path(@website),
                notice: t('admin.communication.website.synchronize.running')
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

  def edit_language
    @l10n = @website.localization_for(current_language)
    breadcrumb
    add_breadcrumb t('admin.subnav.settings'), edit_admin_communication_website_path(@website, website_id: nil)
    add_breadcrumb current_language
  end

  def edit_federation
    @l10n = @website.localization_for(current_language)
    @source_websites = current_university.websites
                                         .where.not(id: @website.id)
                                         .ordered(current_language)
    breadcrumb
    add_breadcrumb t('admin.subnav.settings'), edit_admin_communication_website_path(@website, website_id: nil)
    add_breadcrumb t('admin.communication.website.federation.label')
  end

  def edit_technical
    @l10n = @website.localization_for(current_language)
    breadcrumb
    add_breadcrumb t('admin.subnav.settings'), edit_admin_communication_website_path(@website, website_id: nil)
    add_breadcrumb t('admin.communication.website.technical.label')
  end

  def create
    if @website.save
      redirect_to [:admin, @website], notice: t('admin.successfully_created_html', model: @website.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @website.update(website_params)
      redirect_to [:admin, @website], notice: t('admin.successfully_updated_html', model: @website.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @website.destroy
    redirect_to admin_communication_websites_url, notice: t('admin.successfully_destroyed_html', model: @website.to_s_in(current_language))
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
    edit_path_method = "edit_admin_#{@about.class.base_class.to_s.parameterize.underscore}_path"
    redirect_to public_send(edit_path_method, { id: @about.id})
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
      :feature_posts, :feature_agenda, :feature_portfolio, :feature_jobboard, :feature_alumni, :feature_syndication, :feature_alerts, :feature_hourly_publication,
      :default_time_zone,
      :deuxfleurs_hosting, :default_image, :default_image_delete, :default_image_infos, :default_shared_image, :default_shared_image_delete, :default_shared_image_infos,
      :deployment_status_badge, :autoupdate_theme, :archive_content, :years_before_archive_content,
      showcase_tag_ids: [], source_website_ids: [],
      localizations_attributes: [
        :id, :language_id, :name, :published,
        :social_mastodon, :social_x, :social_linkedin, :social_youtube,
        :social_vimeo, :social_peertube, :social_instagram, :social_facebook,
        :social_tiktok, :social_email, :social_github
      ]
    ]
    attribute_names << :access_token unless params[:communication_website][:access_token].blank?
    attribute_names << :default_language_id if @website&.persisted?
    params.require(:communication_website)
          .permit(*attribute_names)
          .merge(
            university_id: current_university.id
          )
  end

end
