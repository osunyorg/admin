class Admin::Education::Program::RolesController < Admin::Education::Program::ApplicationController
  load_and_authorize_resource class: Education::Program::Role, through: :program

  include Admin::Reorderable

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
    add_breadcrumb Education::Program::Role.model_name.human(count: 2)
    breadcrumb_for @role
  end

  def role_params
    params.require(:education_program_role)
          .permit(:title)
          .merge(program_id: @program.id, university_id: current_university.id)
  end
end
