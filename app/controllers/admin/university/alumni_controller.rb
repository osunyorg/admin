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

  def breadcrumb
    super
    add_breadcrumb  University::Person::Alumnus.model_name.human(count: 2),
                    admin_university_alumni_path
    add_breadcrumb @alumnus, admin_university_alumni_path(@alumnus) if @alumnus
  end

end
