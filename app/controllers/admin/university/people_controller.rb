class Admin::University::PeopleController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Person,
                              through: :current_university,
                              through_association: :people


  has_scope :for_search_term
  has_scope :for_category
  has_scope :for_role

  def index
    @people = apply_scopes(@people)
                .for_language_id(current_university.default_language_id)
                .ordered
                .page(params[:page])
    @categories = current_university.people_categories.ordered.page(params[:categories_page])

    breadcrumb
  end

  def show
    @teacher_involvements = @person.involvements_as_teacher.includes(:target).ordered_by_date.page(params[:programs_page])
    @administrator_involvements = @person.involvements_as_administrator.includes(:target).ordered_by_date.page(params[:roles_page])
    breadcrumb
  end

  def in_language
    language = Language.find_by!(iso_code: params[:lang])
    translation = @person.find_or_translate!(language)
    if translation.newly_translated
      # There's an attribute accessor named "newly_translated" that we set to true
      # when we just created the translation. We use it to redirect to the form instead of the show.
      redirect_to [:edit, :admin, translation.becomes(translation.class.base_class)]
    else
      redirect_to [:admin, translation.becomes(translation.class.base_class)]
    end
  end

  def static
    @about = @person
    @website = @person.websites&.first
    render layout: false
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @person.language_id = current_university.default_language_id
    if @person.save_and_sync
      redirect_to admin_university_person_path(@person),
                  notice: t('admin.successfully_created_html', model: @person.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @person.update_and_sync(person_params)
      redirect_to admin_university_person_path(@person),
                  notice: t('admin.successfully_updated_html', model: @person.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy_and_sync
    redirect_to admin_university_people_url,
                notice: t('admin.successfully_destroyed_html', model: @person.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  University::Person.model_name.human(count: 2),
                    admin_university_people_path
    breadcrumb_for @person
  end

  def person_params
    params.require(:university_person).permit(
      :slug, :first_name, :last_name, :email, :gender, :birthdate,
      :phone_mobile, :phone_professional, :phone_personal,
      :address, :zipcode, :city, :country,
      :meta_description, :summary,
      :biography,  :picture, :picture_delete, :picture_infos,
      :habilitation, :tenure, :url, :linkedin, :twitter, :mastodon,
      :is_researcher, :is_teacher, :is_administration, :is_alumnus, :user_id,
      category_ids: []
    ).merge(university_id: current_university.id)
  end
end
