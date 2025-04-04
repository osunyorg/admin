class Admin::University::PeopleController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Person,
                              through: :current_university,
                              through_association: :people

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @people = @people.filter_by(params[:filters], current_language)
                     .ordered(current_language)
    @feature_nav = 'navigation/admin/university/people'
    respond_to do |format|
      format.html {
        @people = @people.page(params[:page])
        breadcrumb
      }
      format.xlsx {
        filename = "people-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
      }
    end
  end

  def search
    @term = params[:term].to_s
    @people = current_university.people
                                .for_search_term(@term, current_language)
                                .ordered(current_language)
  end

  def show
    @teacher_involvements = @person.involvements_as_teacher
                                   .includes(:target)
                                   .ordered_by_date
                                   .page(params[:programs_page])
    @administrator_involvements = @person.involvements_as_administrator
                                         .includes(:target)
                                         .ordered_by_date
                                         .page(params[:roles_page])
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
    @person.created_by = current_user
    if @person.save
      redirect_to admin_university_person_path(@person),
                  notice: t('admin.successfully_created_html', model: @person.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @person.update(person_params)
      redirect_to admin_university_person_path(@person),
                  notice: t('admin.successfully_updated_html', model: @person.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy
    redirect_to admin_university_people_url,
                notice: t('admin.successfully_destroyed_html', model: @person.to_s_in(current_language))
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
      :email, :email_visibility, :gender, :birthdate,
      :phone_mobile, :phone_mobile_visibility, :phone_professional, :phone_professional_visibility, :phone_personal, :phone_personal_visibility,
      :address, :zipcode, :city, :country, :address_visibility,
      :picture, :picture_delete, :picture_infos,
      :habilitation, :tenure,
      :linkedin_visibility, :twitter_visibility, :mastodon_visibility,
      :is_researcher, :is_teacher, :is_administration, :is_alumnus, :is_author, :user_id,
      research_laboratory_ids: [], category_ids: [],
      localizations_attributes: [
        :id, :slug, :first_name, :last_name,
        :meta_description, :summary, :biography,
        :picture_credit,
        :url, :linkedin, :twitter, :mastodon,
        :language_id
      ]
    ).merge(university_id: current_university.id)
  end

  def categories
    current_university.person_categories
                      .ordered(current_language)
  end
end
