class Admin::Communication::WebsitesController < Admin::Communication::ApplicationController
  load_and_authorize_resource class: Communication::Website

  def index
    @websites = current_university.communication_websites
    breadcrumb
  end

  def show
    breadcrumb
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
    if @website.save
      redirect_to [:admin, @website], notice: t('admin.successfully_created_html', model: @website.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @website.update(website_params)
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
    params.require(:communication_website).permit(:name, :domain, :repository, :access_token, :about_type, :about_id)
  end
end
