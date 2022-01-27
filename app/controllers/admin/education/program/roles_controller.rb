class Admin::Education::Program::RolesController < Admin::Education::Program::ApplicationController
  load_and_authorize_resource class: University::Role, through: :program, through_association: :university_roles

  include Admin::Reorderable

  def reorder
    super { |first_role| first_role.sync_program }
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
    add_breadcrumb University::Role.model_name.human(count: 2)
    if @role
      @role.persisted?  ? add_breadcrumb(@role, admin_education_program_role_path(@role, { program_id: @program.id }))
                        : add_breadcrumb(t('create'))
    end
  end

  def role_params
    params.require(:university_role)
          .permit(:description, :position)
          .merge(target: @program, university_id: current_university.id)
  end
end
