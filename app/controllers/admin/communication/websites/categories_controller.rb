class Admin::Communication::Websites::CategoriesController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Category, through: :website

  include Admin::Translatable

  before_action :get_root_categories, only: [:index, :new, :create, :edit, :update]

  def index
    @categories = @website.categories.where(language_id: current_website_language.id).ordered
    breadcrumb
  end

  def reorder
    parent_id = params[:parentId].blank? ? nil : params[:parentId]
    ids = params[:ids] || []
    first_category = nil
    ids.each.with_index do |id, index|
      category = @website.categories.find(id)
      first_category = category if index == 0
      category.update(
        parent_id: parent_id,
        position: index + 1
      )
    end
    if parent_id
      parent = @website.categories.find(parent_id)
      parent.sync_with_git
    else
      first_category&.sync_with_git # Will sync siblings
    end
  end

  def children
    return unless request.xhr?
    @category = @website.categories.where(language_id: current_website_language.id).find(params[:id])
    @children = @category.children.ordered
  end

  def show
    @posts = @category.posts.ordered.page(params[:page])
    breadcrumb
  end

  def static
    @about = @category
    render layout: false
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
    @category.add_unsplash_image params[:unsplash]
    if @category.save_and_sync
      redirect_to admin_communication_website_category_path(@category), notice: t('admin.successfully_created_html', model: @category.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category.add_unsplash_image params[:unsplash]
    if @category.update_and_sync(category_params)
      redirect_to admin_communication_website_category_path(@category), notice: t('admin.successfully_updated_html', model: @category.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy_and_sync
    redirect_to admin_communication_website_categories_url, notice: t('admin.successfully_destroyed_html', model: @category.to_s)
  end

  protected

  def get_root_categories
    @root_categories = @website.categories.root.where(language_id: current_website_language.id).ordered
  end

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Category.model_name.human(count: 2),
                    admin_communication_website_categories_path
    breadcrumb_for @category
  end

  def category_params
    translatable_params(
      :communication_website_category,
      [
        :name, :meta_description, :summary, :slug, :parent_id,
        :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit
      ]
    )
  end
end
