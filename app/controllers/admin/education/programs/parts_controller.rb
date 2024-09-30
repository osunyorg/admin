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

  def pedagogy
    @teacher_involvements = @program.university_person_involvements.includes(:person).ordered_by_name(current_language)
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

  def authorize_resource
    authorize! :read, resource
  end

  def resource
    @program
  end
end
