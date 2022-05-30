class Admin::University::Alumni::Cohorts::ImportsController < Admin::University::ApplicationController
  load_and_authorize_resource class: Import,
                              through: :current_university,
                              through_association: :imports

  has_scope :for_status

  def index
    @imports = apply_scopes(@imports.kind_alumni_cohorts).ordered.page(params[:page])
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
    @import.university = current_university
    @import.user = current_user
    if @import.save
      redirect_to admin_university_alumni_cohorts_import_path(@import),
                  notice: t('admin.successfully_created_html', model: @import.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  University::Person::Alumnus.model_name.human(count: 2),
                    admin_university_alumni_path
    add_breadcrumb  t('university.alumni.cohorts.title'),
                    admin_university_alumni_cohorts_imports_path
    return unless @import
    @import.persisted?  ? add_breadcrumb(@import, admin_university_alumni_cohorts_import_path(@import))
                        : add_breadcrumb(t('create'))
  end

  def import_params
    params.require(:import)
          .permit(:file)
  end
end
