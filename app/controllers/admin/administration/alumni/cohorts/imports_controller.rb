class Admin::Administration::Alumni::Cohorts::ImportsController < Admin::Administration::ApplicationController
  load_and_authorize_resource class: Import,
                              through: :current_university,
                              through_association: :imports

  def index
    @imports = @imports.kind_alumni_cohorts
                       .filter_by(params[:filters], current_language)
                       .ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
    render 'admin/imports/show'
  end

  def new
    breadcrumb
  end

  def create
    @import.kind = :alumni_cohorts
    @import.user = current_user
    @import.language = current_language
    if @import.save
      redirect_to admin_administration_alumni_cohorts_import_path(@import),
                  notice: t('admin.successfully_created_html', model: @import.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def breadcrumb
    add_breadcrumb t('admin.dashboard'), admin_root_path(website_id: nil)
    add_breadcrumb  Administration.model_name.human, admin_administration_root_path
    add_breadcrumb  University::Person::Alumnus.model_name.human(count: 2), admin_administration_alumni_path
    add_breadcrumb  t('university.alumni.cohorts.title'), admin_administration_alumni_cohorts_imports_path
    return unless @import
    @import.persisted?  ? add_breadcrumb(@import, admin_administration_alumni_cohorts_import_path(@import))
                        : add_breadcrumb(t('create'))
  end

  def import_params
    params.require(:import)
          .permit(:file)
          .merge(
            university_id: current_university.id
          )
  end
end
