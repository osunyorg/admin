class Admin::Communication::Websites::Posts::CategoriesController < Admin::Communication::Websites::Posts::ApplicationController
  load_and_authorize_resource class: Communication::Website::Post::Category,
                              through: :website,
                              through_association: :post_categories

  include Admin::Translatable

  before_action :get_root_categories, only: [:index, :new, :create, :edit, :update]

  def index
    @categories = @website.post_categories.for_language(current_website_language).ordered
    breadcrumb
  end

  def reorder
    parent_id = params.dig(:parentId)
    old_parent_id = params.dig(:oldParentId)
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      category = @website.post_categories.find(id)
      category.update_columns parent_id: parent_id,
                              position: index + 1
    end
    if old_parent_id
      old_parent = @website.post_categories.find(old_parent_id)
      old_parent.sync_with_git
    end
    @website.post_categories.find(params[:itemId]).sync_with_git # Will sync siblings
  end

  def children
    return unless request.xhr?
    @category = @website.post_categories.for_language(current_website_language).find(params[:id])
    @children = @category.children.ordered
  end

  def show
    @posts = @category.posts.ordered.page(params[:page])
    breadcrumb
  end

  def static
    @about = @category
    render_as_plain_text
  end

  def new
    @category.website = @website
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @category.website = @website
    @category.add_photo_import params[:photo_import]
    if @category.save_and_sync
      redirect_to admin_communication_website_post_category_path(@category), notice: t('admin.successfully_created_html', model: @category.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category.add_photo_import params[:photo_import]
    if @category.update_and_sync(category_params)
      redirect_to admin_communication_website_post_category_path(@category), notice: t('admin.successfully_updated_html', model: @category.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_communication_website_categories_url, notice: t('admin.successfully_destroyed_html', model: @category.to_s)
  end

  protected

  def get_root_categories
    @root_categories = @website.post_categories.root.for_language(current_website_language).ordered
  end

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Post::Category.model_name.human(count: 2),
                    admin_communication_website_post_categories_path
    breadcrumb_for @category
  end

  def category_params
    params.require(:communication_website_post_category)
          .permit(
            :name, :meta_description, :summary, :slug, :parent_id,
            :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit
          )
          .merge(
            university_id: current_university.id,
            language_id: current_website_language.id
          )
  end
end
