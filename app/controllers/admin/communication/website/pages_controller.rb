class Admin::Communication::Website::PagesController < Admin::Communication::Website::ApplicationController
  load_and_authorize_resource class: Communication::Website::Page, through: :website

  def index
    @homepage = @website.pages.kind_home.first
    @first_level_pages = @homepage.children.ordered
    breadcrumb
  end

  def reorder
    parent_id = params[:parentId].blank? ? nil : params[:parentId]
    ids = params[:ids] || []
    first_page = nil
    ids.each.with_index do |id, index|
      page = @website.pages.find(id)
      first_page = page if index == 0
      page.update(
        parent_id: parent_id,
        position: index + 1
      )
    end
    first_page.sync_with_git if first_page
  end

  def children
    return unless request.xhr?
    @children = @page.children.ordered
  end

  def show
    breadcrumb
  end

  def static
    @about = @page
    render layout: false
  end

  def new
    @page.website = @website
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @page.website = @website
    if @page.save_and_sync
      redirect_to admin_communication_website_page_path(@page), notice: t('admin.successfully_created_html', model: @page.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @page.update_and_sync(page_params)
      redirect_to admin_communication_website_page_path(@page), notice: t('admin.successfully_updated_html', model: @page.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @page.is_special_page?
      redirect_back(fallback_location: admin_communication_website_page_path(@page), alert: t('admin.communication.website.pages.delete_special_page_notice'))
    else
      @page.destroy_and_sync
      redirect_to admin_communication_website_pages_url(@website), notice: t('admin.successfully_destroyed_html', model: @page.to_s)
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Page.model_name.human(count: 2),
                    admin_communication_website_pages_path
    breadcrumb_for @page
  end

  def page_params
    params.require(:communication_website_page)
          .permit(:communication_website_id, :title, :breadcrumb_title,
            :description, :description_short, :header_text, :text, :about_type, :about_id, :slug, :published,
            :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt,
            :parent_id, :related_category_id)
          .merge(university_id: current_university.id)
  end
end
