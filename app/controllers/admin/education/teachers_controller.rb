class Admin::Education::TeachersController < Admin::Education::ApplicationController
  before_action :get_teacher, except: :index

  def index
    @teachers = current_university.people.teachers.accessible_by(current_ability).ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
    @programs = @teacher.education_programs.ordered.page(params[:page])
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def update
    if @teacher.update(teacher_params)
      redirect_to admin_education_teacher_path(@teacher), notice: t('admin.successfully_updated_html', model: @teacher.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  def get_teacher
    @teacher = current_university.people.teachers.accessible_by(current_ability).find(params[:id])
  end

  def breadcrumb
    super
    add_breadcrumb  t('education.teachers', count: 2),
                    admin_education_teachers_path
    breadcrumb_for @teacher
  end

  def teacher_params
    params.require(:university_person)
          .permit(education_program_ids: [])
  end
end
