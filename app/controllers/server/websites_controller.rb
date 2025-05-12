class Server::WebsitesController < Server::ApplicationController

  before_action :load_websites, only: [:index, :clean_and_rebuild_all_websites]
  before_action :load_website, except: [:index, :clean_and_rebuild_all_websites]

  def index
    @websites = @websites.ordered(current_language).page(params[:page]).per(500)
    breadcrumb
  end

  def clean_and_rebuild_all_websites
    @websites.find_each do |website|
      website.clean_and_rebuild
    end
    redirect_back(fallback_location: server_websites_path, notice: t('server_admin.websites.clean_and_rebuild_all_websites_notice'))
  end

  def clean_and_rebuild
    @website.clean_and_rebuild
    redirect_back(fallback_location: server_website_path(@website), notice: t('server_admin.websites.clean_and_rebuild_website_notice'))
  end

  def sync_theme_version
    @website.get_current_theme_version!
  end

  def update_theme
    @website.update_theme_version
  end

  def unlock_for_background_jobs
    @website.unlock_for_background_jobs!
    redirect_back(fallback_location: server_website_path(@website), notice: t('server_admin.websites.unlock_for_background_jobs_notice'))
  end

  def show
    @layouts = @website.git_file_layouts.ordered
    breadcrumb
  end

  def analyse
    @website.analyse_repository!
    redirect_back fallback_location: server_website_path(@website),
                  notice: t('admin.communication.website.git_file.analysis.launched')
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def update
    if params[:context] == 'showcase_highlight'
      should_highlight = params.dig(:communication_website, :highlighted_in_showcase) == '1'
      @website.update(highlighted_in_showcase: should_highlight)
    else
      university_id = params.dig(:communication_website, :university_id)
      @website.move_to_university(university_id) if university_id
      redirect_to server_website_path(@website), notice: t('admin.successfully_updated_html', model: @website.to_s)
    end
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
    @websites = Communication::Website.filter_by(params[:filters], current_language).ordered(current_language)
  end

  def load_website
    @website = Communication::Website.find params[:id]
  end

end
