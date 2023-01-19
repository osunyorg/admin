class Admin::Communication::Websites::PagesController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Page,
                              through: :website

  include Admin::Translatable

  def index
    @homepage = @website.special_page(Communication::Website::Page::Home)
    @first_level_pages = @homepage.children.ordered
    breadcrumb
  end

  def reorder
    parent_page = @website.pages.find(params[:parentId])
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      page = @website.pages.find(id)
      page.update(
        parent_id: parent_page.id,
        position: index + 1
      )
    end
    parent_page.sync_with_git
  end

  def children
    return unless request.xhr?
    @children = @page.children.ordered
  end

  def show
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

  def translate
    language = @website.languages.find_by!(iso_code: params[:iso_code])
    if @page.language_id == language.id
      redirect_to [:admin, @page]
    else
      @translation = @page.translation_for(language)
      # If not found, duplicate the current page (with blocks and all) for given language
      @translation ||= @page.duplicate!(language_id: language.id)
      # Redirect to the translation
      redirect_to [:admin, @translation.becomes(@translation.class.base_class)]
    end
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
    @page.add_unsplash_image params[:unsplash]
    if @page.save_and_sync
      redirect_to admin_communication_website_page_path(@page), notice: t('admin.successfully_created_html', model: @page.to_s)
    else
      breadcrumb
      add_breadcrumb(t('create'))
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @page.add_unsplash_image params[:unsplash]
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
      @page.destroy_and_sync
      redirect_to admin_communication_website_pages_url(@website), notice: t('admin.successfully_destroyed_html', model: @page.to_s)
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  t('admin.communication.website.pages.structure'),
                    admin_communication_website_pages_path
  end

  def page_params
    translatable_params(
      :communication_website_page,
      [
        :communication_website_id, :title, :breadcrumb_title, :bodyclass,
        :meta_description, :summary, :header_text, :text, :slug, :published, :full_width,
        :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
        :parent_id
      ],
      @website.default_language_id,
      @website.languages.size
    )
  end
end
