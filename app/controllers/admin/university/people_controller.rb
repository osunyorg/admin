class Admin::University::PeopleController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Person,
                              through: :current_university,
                              through_association: :people

  def index
    @people = @people.ordered.page(params[:page])
    breadcrumb
  end

  def show
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
    if @person.save_and_sync
      redirect_to admin_university_person_path(@person), notice: t('admin.successfully_created_html', model: @person.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @person.update_and_sync(person_params)
      redirect_to admin_university_person_path(@person), notice: t('admin.successfully_updated_html', model: @person.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy_and_sync
    redirect_to admin_university_people_url, notice: t('admin.successfully_destroyed_html', model: @person.to_s)
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
      :slug, :first_name, :last_name, :email, :phone,
      :biography,  :picture, :picture_delete, :picture_infos,
      :is_researcher, :is_teacher, :is_administration, :user_id
    ).merge(university_id: current_university.id)
  end
end
