class Admin::Education::Program::TeachersController < Admin::Education::Program::ApplicationController
  load_and_authorize_resource class: Education::Program::Teacher, through: :program

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @teacher.save
      redirect_to admin_education_program_path(@program), notice: t('admin.successfully_created_html', model: @teacher.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @teacher.update(teacher_params)
      redirect_to admin_education_program_path(@program), notice: t('admin.successfully_updated_html', model: @teacher.to_s)
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @teacher.destroy
    redirect_to admin_education_program_path(@program), notice: t('admin.successfully_destroyed_html', model: @teacher.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education::Program::Teacher.model_name.human(count: 2)
    breadcrumb_for @teacher
  end

  def teacher_params
    params.require(:education_program_teacher)
          .permit(:description, :person_id)
          .merge(program_id: @program.id)
  end
end
