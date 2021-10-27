class Admin::Communication::Website::CategoriesController < Admin::Communication::Website::ApplicationController
  load_and_authorize_resource class: Communication::Website::Category

  include Admin::Reorderable

  def index
    @categories = @website.categories.ordered
    breadcrumb
  end

  def show
    breadcrumb
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
    @category.university = current_university
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

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Category.model_name.human(count: 2),
                    admin_communication_website_categories_path
    breadcrumb_for @category
  end

  def category_params
    params.require(:communication_website_category)
          .permit(:university_id, :website_id, :name, :description)
  end
end
