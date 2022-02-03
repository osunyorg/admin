class Admin::Education::School::Role::PeopleController < Admin::Education::School::ApplicationController
  load_and_authorize_resource :role, class: University::Role, through: :school, param: :role_id, through_association: :university_roles
  load_and_authorize_resource :involvement, class: University::Person::Involvement, through: :role, parent: false

  include Admin::Reorderable

  before_action :get_available_people, except: [:reorder, :destroy]

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @involvement.save
      redirect_to admin_education_school_role_path(@role, { school_id: @school.id }), notice: t('admin.successfully_created_html', model: @involvement.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @involvement.update(involvement_params)
      redirect_to admin_education_school_role_path(@role, { school_id: @school.id }), notice: t('admin.successfully_updated_html', model: @involvement.to_s)
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @involvement.destroy
    redirect_to admin_education_school_role_path(@role, { school_id: @school.id }), notice: t('admin.successfully_destroyed_html', model: @involvement.to_s)
  end

  protected

  def get_available_people
    used_person_ids = @role.involvements.where.not(id: @involvement.id).pluck(:person_id)
    @available_people = current_university.people.administration.where.not(id: used_person_ids).accessible_by(current_ability).ordered
  end

  def breadcrumb
    super
    add_breadcrumb University::Role.model_name.human(count: 2), admin_education_school_roles_path(@school)
    add_breadcrumb(@role, admin_education_school_role_path(@role, { school_id: @school.id }))
    if @involvement
      @involvement.persisted?  ? add_breadcrumb(@involvement, admin_education_school_role_person_path(@involvement, { school_id: @school.id, role_id: @role.id }))
                               : add_breadcrumb(t('create'))
    end
  end

  def involvement_params
    params.require(:university_person_involvement).permit(:position, :person_id)
  end

  def model
    University::Person::Involvement
  end
end
