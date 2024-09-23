class Admin::Education::Programs::CategoriesController < Admin::Education::Programs::ApplicationController
  load_and_authorize_resource class: Education::Program::Category,
                              through: :current_university,
                              through_association: :program_categories

  include Admin::ActAsCategories
  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @root_categories = categories.root
                                 .ordered
    @categories_class = categories_class
    @feature_nav = 'navigation/admin/education/programs'
    breadcrumb
  end

  def show
    @programs =  @category.programs
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
      redirect_to admin_education_program_category_path(@category),
                  notice: t('admin.successfully_created_html', model: @category.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_education_program_category_path(@category),
                  notice: t('admin.successfully_updated_html', model: @category.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_education_program_categories_path,
                notice: t('admin.successfully_destroyed_html', model: @category.to_s_in(current_language))
  end

  protected

  def categories_class
    Education::Program::Category
  end

  def categories
    current_university.program_categories
                      .ordered
  end

  def breadcrumb
    super
    add_breadcrumb  Education::Program::Category.model_name.human(count: 2),
                    admin_education_program_categories_path
    breadcrumb_for @category
  end

  def category_params
    params.require(:education_program_category).permit(
      :is_taxonomy, :parent_id,
      localizations_attributes: [
        :id, :name, :slug, :language_id
      ]).merge(university_id: current_university.id)
  end
end