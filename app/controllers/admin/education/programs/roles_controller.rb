class Admin::Education::Programs::RolesController < Admin::Education::Programs::ApplicationController
  load_and_authorize_resource class: University::Role, through: :program, through_association: :university_roles

  include Admin::Reorderable

  before_action :load_administration_people, only: [:new, :edit, :create, :update]

  def index
    @roles = @roles.ordered
    breadcrumb
  end

  def show
    @involvements = @role.involvements.ordered
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
    if @role.save
      redirect_to admin_education_program_role_path(@role), notice: t('admin.successfully_created_html', model: @role.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @role.update(role_params)
      redirect_to admin_education_program_role_path(@role), notice: t('admin.successfully_updated_html', model: @role.to_s)
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @role.destroy
    redirect_to admin_education_program_path(@program), notice: t('admin.successfully_destroyed_html', model: @role.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Role.model_name.human(count: 2), admin_education_program_roles_path(@program)
    if @role
      @role.persisted?  ? add_breadcrumb(@role, admin_education_program_role_path(@role, { program_id: @program.id }))
                        : add_breadcrumb(t('create'))
    end
  end

  def role_params
    params.require(:university_role)
          .permit(:description, involvements_attributes: [:id, :person_id, :position, :_destroy])
          .merge(target: @program, university_id: current_university.id)
  end

  def model
    University::Role
  end

  def load_administration_people
    @administration_people = current_university.people.where(language_id: current_university.default_language_id).administration.accessible_by(current_ability).ordered
  end
end
