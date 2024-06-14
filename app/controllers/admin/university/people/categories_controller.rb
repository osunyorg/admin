class Admin::University::People::CategoriesController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Person::Category,
                              through: :current_university,
                              through_association: :person_categories

  include Admin::Categorizable

  def index
    @root_categories = categories.root
    @categories_class = categories_class
    @feature_nav = 'navigation/admin/university/people'
    breadcrumb
  end

  def show
    @people = @category.people.ordered.page(params[:page])
    breadcrumb
  end

  def in_language
    language = Language.find_by!(iso_code: params[:lang])
    translation = @category.find_or_translate!(language)
    if translation.newly_translated
      # There's an attribute accessor named "newly_translated" that we set to true
      # when we just created the translation. We use it to redirect to the form instead of the show.
      redirect_to [:edit, :admin, translation.becomes(translation.class.base_class)]
    else
      redirect_to [:admin, translation.becomes(translation.class.base_class)]
    end
  end

  def static
    @about = @category
    @website = @category.websites&.first
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
    @category.language_id = current_university.default_language_id
    if @category.save
      redirect_to admin_university_person_category_path(@category),
                  notice: t('admin.successfully_created_html', model: @category.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_university_person_category_path(@category),
                  notice: t('admin.successfully_updated_html', model: @category.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_university_person_categories_path,
                notice: t('admin.successfully_destroyed_html', model: @category.to_s)
  end

  protected

  def categories_class
    University::Person::Category
  end

  def categories
    current_university.person_categories.ordered
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
      :name).merge(university_id: current_university.id)
  end
end
