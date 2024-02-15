class Server::WebsitesController < Server::ApplicationController

  before_action :load_websites, only: [:index, :clean_and_rebuild_all_websites]
  before_action :load_website, except: [:index, :clean_and_rebuild_all_websites]

  has_scope :for_theme_version
  has_scope :for_production
  has_scope :for_update
  has_scope :for_search_term
  has_scope :for_updatable_theme

  def index
    @websites = @websites.ordered.page(params[:page]).per(100)
    breadcrumb
  end

  def clean_and_rebuild_all_websites
    @websites.find_each do |website|
      website.clean_and_rebuild
    end
    redirect_back(fallback_location: server_websites_path, notice: t('server_admin.websites.clean_and_rebuild_all_websites_notice'))
  end

  def sync_theme_version
    @website.get_current_theme_version!
  end

  def update_theme
    @website.update_theme_version
  end

  def show
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def update
    university_id = params.dig(:communication_website, :university_id)
    @website.move_to_university(university_id) if university_id
    redirect_to server_website_path(@website), notice: t('admin.successfully_updated_html', model: @website.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website.model_name.human(count: 2), server_websites_path
    if @website
      add_breadcrumb @website, server_website_path(@website)
    end
  end

  def load_websites
    @websites = apply_scopes(Communication::Website.all).ordered
  end

  def load_website
    @website = Communication::Website.find params[:id]
  end

end
