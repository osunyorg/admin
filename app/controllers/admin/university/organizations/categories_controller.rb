class Admin::University::Organizations::CategoriesController < Admin::University::ApplicationController
  load_and_authorize_resource class: 'University::Organization::Category',
                              through: :current_university,
                              through_association: :organization_categories

  include Admin::ActAsCategories
  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @root_categories = categories.root.ordered(current_language)
    @categories_class = categories_class
    @feature_nav = 'navigation/admin/university/organizations'
    breadcrumb
  end

  def show
    @organizations = @category.organizations.ordered(current_language).page(params[:page])
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
      redirect_to admin_university_organization_category_path(@category),
                  notice: t('admin.successfully_created_html', model: @category.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_university_organization_category_path(@category),
                  notice: t('admin.successfully_updated_html', model: @category.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_university_organization_categories_path,
                notice: t('admin.successfully_destroyed_html', model: @category.to_s_in(current_language))
  end

  protected

  def categories_class
    University::Organization::Category
  end

  def categories
    current_university.organization_categories
                      .ordered(current_language)
  end

  def breadcrumb
    super
    add_breadcrumb  University::Organization.model_name.human(count: 2),
                    admin_university_organizations_path
    add_breadcrumb  University::Organization::Category.model_name.human(count: 2),
                    admin_university_organization_categories_path
    breadcrumb_for @category
  end

  def category_params
    permitted_params_for(:university_organization_category)
  end
end
