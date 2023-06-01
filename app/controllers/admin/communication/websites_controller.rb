class Admin::Communication::WebsitesController < Admin::Communication::Websites::ApplicationController
  has_scope :for_search_term
  has_scope :for_about_type

  def index
    @websites = apply_scopes(@websites).ordered.page(params[:page])
    breadcrumb
  end

  def show
    @all_pages = @website.pages.accessible_by(current_ability).for_language(current_website_language)
    @pages = @all_pages.recent
    @all_posts = @website.posts.accessible_by(current_ability).for_language(current_website_language)
    @posts = @all_posts.recent
    breadcrumb
  end

  def analytics
    breadcrumb
    add_breadcrumb t('communication.website.analytics')
  end

  def new
    breadcrumb
  end

  def import
    if request.post?
      @website.import!
      flash[:notice] = t('communication.website.imported.launched')
    end
    @imported_website = @website.imported_website
    @imported_pages = @imported_website.pages.page params[:pages_page]
    @imported_posts = @imported_website.posts.page params[:posts_page]
    @imported_authors = @imported_website.authors.page params[:authors_page]
    @imported_categories = @imported_website.categories
    @imported_media = @imported_website.media.includes(file_attachment: :blob ).page params[:media_page]
    @imported_media_total_size = @imported_website.media.joins(file_attachment: :blob).sum(:byte_size)
    breadcrumb
    add_breadcrumb Communication::Website::Imported::Website.model_name.human
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
      :name, :url, :repository, :access_token, :about_type, :about_id, :in_production,
      :git_provider, :git_endpoint, :git_branch, :plausible_url, language_ids: []
    ]
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
