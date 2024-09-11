class Admin::Education::Programs::PartsController < Admin::Education::Programs::ApplicationController
  before_action :load_program

  def presentation
    breadcrumb
    add_breadcrumb t('education.program.parts.presentation.label')
  end

  def pedagogy
    @teacher_involvements = @program.university_person_involvements.includes(:person).ordered_by_name
    breadcrumb
    add_breadcrumb t('education.program.parts.pedagogy.label')
  end

  def results
    breadcrumb
    add_breadcrumb t('education.program.parts.results.label')
  end

  def admission
    @roles = @program.university_roles.ordered
    breadcrumb
    add_breadcrumb t('education.program.parts.admission.label')
  end

  def certification
    breadcrumb
    add_breadcrumb t('education.program.parts.certification.label')
  end
  
  def alumni
    @cohorts = @program.cohorts.ordered
    breadcrumb
    add_breadcrumb University::Person::Alumnus.model_name.human(count: 2)
  end

  protected

  def load_program
    @program = current_university.education_programs.find(params[:id])
    @l10n = @program.localization_for(current_language)
    authorize! :show, @program
  end
end
