class Admin::Communication::Website::CategoriesController < Admin::Communication::Website::ApplicationController
  load_and_authorize_resource class: Communication::Website::Category, through: :website

  before_action :get_root_categories, only: [:index, :new, :create, :edit, :update]

  def index
    @categories = @website.categories.ordered
    breadcrumb
  end

  def reorder
    parent_id = params[:parentId].blank? ? nil : params[:parentId]
    ids = params[:ids] || []
    categories = []
    ids.each.with_index do |id, index|
      category = @website.categories.find(id)
      categories << category
      categories.concat(category.descendents) if parent_id != category.parent_id
      category.update(
        parent_id: parent_id,
        position: index + 1,
        skip_github_publication: true
      )
    end
    github = Github.with_website @website
    github.send_batch_to_website(categories, message: '[Category] Reorder categories.')
  end

  def children
    return unless request.xhr?
    @category = @website.categories.find(params[:id])
    @children = @category.children.ordered
  end

  def show
    @posts = @category.posts.ordered.page(params[:page])
    breadcrumb
  end

  def publish
    @category.force_publish!
    redirect_to admin_communication_website_category_path(@category), notice: t('admin.will_be_published_html', model: @category.to_s)
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
    if @category.save
      redirect_to admin_communication_website_category_path(@category), notice: t('admin.successfully_created_html', model: @category.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_communication_website_category_path(@category), notice: t('admin.successfully_updated_html', model: @category.to_s)
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
    @root_categories = @website.categories.root.ordered
  end

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Category.model_name.human(count: 2),
                    admin_communication_website_categories_path
    breadcrumb_for @category
  end

  def category_params
    params.require(:communication_website_category)
          .permit(:website_id, :name, :description, :slug, :parent_id)
          .merge(university_id: current_university.id)
  end
end
