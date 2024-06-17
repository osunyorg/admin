class Admin::University::AlumniController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Person::Alumnus,
                              through: :current_university,
                              through_association: :people

  has_scope :for_search_term
  has_scope :for_alumni_organization
  has_scope :for_alumni_program
  has_scope :for_alumni_year

  def index
    @alumni = apply_scopes(@alumni)
                .for_language_id(current_university.default_language_id)
                .alumni
                .accessible_by(current_ability)
                .ordered
                .page(params[:page])
    breadcrumb
  end

  def show
    @cohorts = @alumnus.cohorts.ordered.page(params[:cohorts_page])
    breadcrumb
  end

  protected

  def current_subnav_context
    'navigation/admin/administration'
  end

  def breadcrumb
    add_breadcrumb t('admin.dashboard'), admin_root_path(website_id: nil)
    add_breadcrumb  Administration.model_name.human, admin_administration_root_path
    add_breadcrumb  University::Person::Alumnus.model_name.human(count: 2), admin_university_alumni_path
    add_breadcrumb @alumnus, admin_university_alumni_path(@alumnus) if @alumnus
  end

end
