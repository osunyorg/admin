class Admin::Communication::Websites::Portfolio::CategoriesController < Admin::Communication::Websites::Portfolio::ApplicationController
  load_and_authorize_resource class: 'Communication::Website::Portfolio::Category', 
                              through: :website,
                              through_association: :portfolio_categories

  include Admin::Translatable
  include Admin::Categorizable

  def index
    @root_categories = categories.root
    @categories_class = categories_class
    @feature_nav = 'navigation/admin/communication/website/portfolio'
    breadcrumb
  end

  def show
    @projects = @category.projects.ordered.page(params[:page])
    breadcrumb
  end

  def static
    @about = @category
    render_as_plain_text
  end

  def new
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
      redirect_to admin_communication_website_portfolio_category_path(@category), notice: t('admin.successfully_created_html', model: @category.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category.add_photo_import params[:photo_import]
    if @category.update_and_sync(category_params)
      redirect_to admin_communication_website_portfolio_category_path(@category), notice: t('admin.successfully_updated_html', model: @category.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_communication_website_portfolio_categories_url, notice: t('admin.successfully_destroyed_html', model: @category.to_s)
  end

  protected

  def categories_class
    Communication::Website::Portfolio::Category
  end

  def breadcrumb
    super
    add_breadcrumb  categories_class.model_name.human(count: 2),
                    admin_communication_website_portfolio_categories_path
    breadcrumb_for @category
  end

  def category_params
    params.require(:communication_website_portfolio_category)
          .permit(
            :name, :meta_description, :summary, :slug,
            :is_taxonomy,
            :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit
          )
          .merge(
            university_id: current_university.id,
            language_id: current_website_language.id
          )
  end
end
