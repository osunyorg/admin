class Admin::Education::TeachersController < Admin::Education::ApplicationController
  load_and_authorize_resource class: Education::Teacher,
                              through: :current_university,
                              through_association: :education_teachers

  def index
    @teachers = @teachers.ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  def publish
    @teacher.force_publish!
    redirect_to admin_education_teacher_path(@teacher), notice: t('admin.will_be_published_html', model: @teacher.to_s)
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @teacher.save
      redirect_to admin_education_teacher_path(@teacher), notice: t('admin.successfully_created_html', model: @teacher.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
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

  def destroy
    @teacher.destroy
    redirect_to admin_education_teachers_url, notice: t('admin.successfully_destroyed_html', model: @teacher.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Education::Teacher.model_name.human(count: 2),
                    admin_education_teachers_path
    breadcrumb_for @teacher
  end

  def teacher_params
    params.require(:education_teacher)
          .permit(:first_name, :last_name, :biography, :slug, :user_id)
          .merge(university_id: current_university.id)
  end
end
