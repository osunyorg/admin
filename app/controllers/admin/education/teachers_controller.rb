class Admin::Education::TeachersController < Admin::Education::ApplicationController
  def index
    @teachers = current_university.people.teachers.accessible_by(current_ability).ordered.page(params[:page])
    breadcrumb
  end

  def show
    @teacher = current_university.people.teachers.accessible_by(current_ability).find(params[:id])
    breadcrumb
    @programs = @teacher.education_programs_as_teacher.ordered.page(params[:page])
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('education.teachers', count: 2), admin_education_teachers_path
    add_breadcrumb @teacher, admin_education_teacher_path(@teacher) if @teacher
  end
end
