class Admin::Education::Programs::PartsController < Admin::Education::Programs::ApplicationController
  include Admin::Localizable

  load_resource :program, class: Education::Program, through: :current_university, parent: false
  before_action :authorize_resource,
                :load_localization,
                :redirect_if_not_localized

  def presentation
    breadcrumb
    add_breadcrumb t('education.program.parts.presentation.label')
  end

  def edit_presentation
    breadcrumb
    add_breadcrumb t('education.program.parts.presentation.label'), presentation_admin_education_program_path(id: @program, program_id: nil)
    add_breadcrumb t('edit')
  end

  def pedagogy
    @teacher_involvements = @program.university_person_involvements
                                    .includes(:person)
                                    .ordered_by_name(current_language)
    breadcrumb
    add_breadcrumb t('education.program.parts.pedagogy.label')
  end

  def edit_pedagogy
    @teacher_people = current_university.people
                                        .teachers
                                        .accessible_by(current_ability)
                                        .ordered(current_language)
    breadcrumb
    add_breadcrumb t('education.program.parts.pedagogy.label'), pedagogy_admin_education_program_path(id: @program, program_id: nil)
    add_breadcrumb t('edit')
  end

  def results
    breadcrumb
    add_breadcrumb t('education.program.parts.results.label')
  end

  def edit_results
    breadcrumb
    add_breadcrumb t('education.program.parts.results.label'), results_admin_education_program_path(id: @program, program_id: nil)
    add_breadcrumb t('edit')
  end

  def admission
    @roles = @program.university_roles.ordered
    breadcrumb
    add_breadcrumb t('education.program.parts.admission.label')
  end

  def edit_admission
    breadcrumb
    add_breadcrumb t('education.program.parts.admission.label'), admission_admin_education_program_path(id: @program, program_id: nil)
    add_breadcrumb t('edit')
  end

  def certification
    breadcrumb
    add_breadcrumb t('education.program.parts.certification.label')
  end

  def edit_certification
    breadcrumb
    add_breadcrumb t('education.program.parts.certification.label'), certification_admin_education_program_path(id: @program, program_id: nil)
    add_breadcrumb t('edit')
  end

  def alumni
    @cohorts = @program.cohorts.ordered
    breadcrumb
    add_breadcrumb University::Person::Alumnus.model_name.human(count: 2)
  end

  protected

  def authorize_resource
    authorize! :read, resource
  end

  def resource
    @program
  end
end
