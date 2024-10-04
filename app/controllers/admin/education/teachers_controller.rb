class Admin::Education::TeachersController < Admin::Education::ApplicationController
  load_and_authorize_resource class: "University::Person",
                              through: :current_university,
                              through_association: :people

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @teachers = current_university.people
                                  .teachers
                                  .filter_by(params[:filters], current_language)
                                  .ordered(current_language)
                                  .page(params[:page])
    breadcrumb
  end

  def show
    @involvements = @teacher.involvements_as_teacher
                            .includes(:target)
                            .ordered_by_date
    breadcrumb
  end

  def static
    @l10n = University::Person::Localization::Teacher.find(@l10n.id)
    super
  end

  def edit
    authorize!(:update, @teacher)
    breadcrumb
    add_breadcrumb t('education.manage_programs')
  end

  def update
    authorize!(:update, @teacher)
    if @teacher.update(teacher_params)
      redirect_to admin_education_teacher_path(@teacher), notice: t('admin.successfully_updated_html', model: @teacher.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('education.manage_programs')
      render :edit
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person::Localization::Teacher.model_name.human(count: 2), admin_education_teachers_path
    add_breadcrumb @l10n, admin_education_teacher_path(@teacher) if @teacher
  end

  def teacher_params
    params.require(:university_person)
          .permit(
            involvements_attributes: [
              :id, :target_id, :target_type, :_destroy,
              localizations_attributes: [:id, :description, :language_id]
            ]
          )
  end
end
