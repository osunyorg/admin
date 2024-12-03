class Admin::University::People::CategoriesController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Person::Category,
                              through: :current_university,
                              through_association: :person_categories

  include Admin::ActAsCategories
  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @root_categories = categories.root.ordered(current_language)
    @categories_class = categories_class
    @feature_nav = 'navigation/admin/university/people'
    breadcrumb
  end

  def show
    @people =  @category.people
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
      redirect_to admin_university_person_category_path(@category),
                  notice: t('admin.successfully_created_html', model: @category.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_university_person_category_path(@category),
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
    redirect_to admin_university_person_categories_path,
                notice: t('admin.successfully_destroyed_html', model: @category.to_s_in(current_language))
  end

  protected

  def categories_class
    University::Person::Category
  end

  def categories
    current_university.person_categories.ordered(current_language)
  end

  def breadcrumb
    super
    add_breadcrumb  University::Person.model_name.human(count: 2),
                    admin_university_people_path
    add_breadcrumb  University::Person::Category.model_name.human(count: 2),
                    admin_university_person_categories_path
    breadcrumb_for @category
  end

  def category_params
    params.require(:university_person_category).permit(
      :is_taxonomy, :parent_id,
      localizations_attributes: [
        :id, :name, :slug, :summary, :meta_description, :language_id,
        :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit
      ]).merge(university_id: current_university.id)
  end
end
