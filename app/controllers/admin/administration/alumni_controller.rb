class Admin::Administration::AlumniController < Admin::Administration::ApplicationController
  load_and_authorize_resource class: University::Person::Alumnus,
                              through: :current_university,
                              through_association: :people

  include Admin::Localizable

  def index
    @alumni = @alumni.filter_by(params[:filters], current_language)
                     .tmp_original # TODO L10N : To remove
                     .alumni
                     .ordered(current_language)
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
    add_breadcrumb Administration.model_name.human, admin_administration_root_path
    add_breadcrumb University::Person::Alumnus.model_name.human(count: 2), admin_administration_alumni_path
    add_breadcrumb @l10n, admin_administration_alumnus_path(@alumnus) if @alumnus
  end

end
