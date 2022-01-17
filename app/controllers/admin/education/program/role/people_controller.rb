class Admin::Education::Program::Role::PeopleController < Admin::Education::Program::ApplicationController
  load_and_authorize_resource :role, class: Education::Program::Role, through: :program
  load_and_authorize_resource class: Education::Program::Role::Person, through: :role

  before_action :get_available_people, except: :destroy

  include Admin::Reorderable

  def new
    breadcrumb
  end

  def create
    if @person.save
      redirect_to admin_education_program_role_path(@role), notice: t('admin.successfully_created_html', model: @person.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy
    redirect_to admin_education_program_role_path(@role), notice: t('admin.successfully_destroyed_html', model: @person.to_s)
  end

  protected

  def get_available_people
    used_person_ids = @role.people.where.not(id: @person.id).pluck(:person_id)
    @available_people = current_university.people.where.not(id: used_person_ids).accessible_by(current_ability).ordered
  end

  def breadcrumb
    super
    add_breadcrumb Education::Program::Role.model_name.human(count: 2)
    breadcrumb_for @role
    add_breadcrumb Education::Program::Role::Person.model_name.human(count: 2)
    breadcrumb_for @person
  end

  def person_params
    params.require(:education_program_role_person)
          .permit(:person_id)
          .merge(role_id: @role.id)
  end
end
