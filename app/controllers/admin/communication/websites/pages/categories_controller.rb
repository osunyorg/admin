class Admin::Communication::Websites::Pages::CategoriesController < Admin::Communication::Websites::Pages::ApplicationController
  load_and_authorize_resource class: 'Communication::Website::Page::Category',
                              through: :website,
                              through_association: :page_categories

  include Admin::ActAsCategories
  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @root_categories = categories.root
    @categories_class = categories_class
    @feature_nav = 'navigation/admin/communication/website/pages'
    breadcrumb
  end

  def show
    @pages = @category.pages
              .ordered_by_title(current_language)
              .page(params[:page])
    breadcrumb
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
    if @category.save_and_sync
      redirect_to admin_communication_website_page_category_path(@category),
                  notice: t('admin.successfully_created_html', model: @category.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update_and_sync(category_params)
      redirect_to admin_communication_website_page_category_path(@category),
                  notice: t('admin.successfully_updated_html', model: @category.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_communication_website_page_categories_url, notice: t('admin.successfully_destroyed_html', model: @category.to_s_in(current_language))
  end

  protected

  def categories_class
    Communication::Website::Page::Category
  end

  def breadcrumb
    super
    add_breadcrumb  categories_class.model_name.human(count: 2),
                    admin_communication_website_page_categories_path
    breadcrumb_for @category
  end

  def category_params
    permitted_params_for(:communication_website_page_category)
  end
end
