class Admin::Communication::Websites::PagesController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Page,
                              through: :website

  include Admin::Translatable

  def index
    @homepage = @website.special_page(Communication::Website::Page::Home, language: current_website_language)
    @first_level_pages = @homepage.children.ordered
    @pages = @website.pages.for_language(current_website_language)
    breadcrumb
  end

  def reorder
    parent_page = @website.pages.find(params[:parentId])
    old_parent_page = @website.pages.find(params[:oldParentId])
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      page = @website.pages.find(id)
      page.update(
        parent_id: parent_page.id,
        position: index + 1
      )
    end
    old_parent_page.sync_with_git
    parent_page.sync_with_git
  end

  def children
    return unless request.xhr?
    @children = @page.children.ordered
  end

  def show
    @preview = true
    breadcrumb
    add_breadcrumb(@page, admin_communication_website_page_path(@page))
  end

  def static
    @about = @page
    render layout: false
  end

  def preview
    render layout: 'admin/layouts/preview'
  end

  def connect
    load_object
    @website.connect_and_sync @object, @page, direct_source_type: @page.class.to_s
    head :ok
  end

  def disconnect
    load_object
    @website.disconnect_and_sync @object, @page, direct_source_type: @page.class.to_s
    redirect_back(fallback_location: [:admin, @object])
  end

  def generate
    @page.generate
    redirect_back(fallback_location: [:admin, @page])
  end

  def new
    @page.website = @website
    breadcrumb
    add_breadcrumb(t('create'))
  end

  def edit
    breadcrumb
    add_breadcrumb(@page, admin_communication_website_page_path(@page))
    add_breadcrumb t('edit')
  end

  def create
    @page.website = @website
    @page.add_photo_import params[:photo_import]
    if @page.save_and_sync
      redirect_to admin_communication_website_page_path(@page), notice: t('admin.successfully_created_html', model: @page.to_s)
    else
      breadcrumb
      add_breadcrumb(t('create'))
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @page.add_photo_import params[:photo_import]
    if @page.update_and_sync(page_params)
      redirect_to admin_communication_website_page_path(@page), notice: t('admin.successfully_updated_html', model: @page.to_s)
    else
      breadcrumb
      add_breadcrumb(@page, admin_communication_website_page_path(@page))
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    redirect_to [:admin, @page.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @page.to_s)
  end

  def destroy
    if @page.is_special_page?
      redirect_back(fallback_location: admin_communication_website_page_path(@page), alert: t('admin.communication.website.pages.delete_special_page_notice'))
    else
      @page.destroy
      redirect_to admin_communication_website_pages_url(@website), notice: t('admin.successfully_destroyed_html', model: @page.to_s)
    end
  end

  protected

  def load_object
    object_type = params[:objectType]
    object_id = params[:objectId]
    @object = object_type.constantize.find object_id
  end

  def breadcrumb
    super
    add_breadcrumb  t('admin.communication.website.pages.structure'),
                    admin_communication_website_pages_path
  end

  def page_params
    params.require(:communication_website_page)
          .permit(
            :communication_website_id, :title, :breadcrumb_title, :bodyclass,
            :meta_description, :summary, :header_text, :text, :slug, :published, :full_width,
            :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
            :parent_id
          )
          .merge(
            university_id: current_university.id,
            language_id: current_website_language.id
          )
  end

end
