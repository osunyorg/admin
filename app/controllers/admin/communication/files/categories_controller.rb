class Admin::Communication::Files::CategoriesController < Admin::Communication::Files::ApplicationController
  load_and_authorize_resource class: Communication::File::Category,
                              through: :current_university,
                              through_association: :communication_file_categories

  include Admin::ActAsCategories
  include Admin::Localizable

  def index
    @root_categories = categories.root.ordered(current_language)
    @categories_class = categories_class
    @feature_nav = 'navigation/admin/communication/files'
    breadcrumb
  end

  def show
    @files =  @category.files
                        .ordered(current_language)
                        .page(params[:page])
    breadcrumb
  end

  def new
    @categories = categories
    breadcrumb
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @category.save
      redirect_to admin_communication_file_category_path(@category),
                  notice: t('admin.successfully_created_html', model: @category.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_communication_file_category_path(@category),
                  notice: t('admin.successfully_updated_html', model: @category.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_communication_file_categories_path,
                notice: t('admin.successfully_destroyed_html', model: @category.to_s_in(current_language))
  end

  protected

  def categories_class
    Communication::File::Category
  end

  def categories
    current_university.file_categories.ordered(current_language)
  end

  def breadcrumb
    super
    add_breadcrumb  Communication::File::Category.model_name.human(count: 2),
                    admin_communication_file_categories_path
    breadcrumb_for @category
  end

  def category_params
    permitted_params_for(:communication_file_category)
  end
end
