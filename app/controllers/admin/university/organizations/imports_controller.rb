class Admin::University::Organizations::ImportsController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Organization::Import,
                              through: :current_university,
                              through_association: :organization_imports

  def index
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def create
    @import.university = current_university
    @import.user = current_user
    if @import.save
      redirect_to [:admin, @import], notice: "Import was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  University::Organization.model_name.human(count: 2),
                    admin_university_organizations_path
    add_breadcrumb  University::Organization::Import.model_name.human(count: 2),
                    admin_university_organizations_imports_path
    return unless @import
    @import.persisted?  ? add_breadcrumb(@import, admin_university_organizations_import_path(@import))
                        : add_breadcrumb(t('create'))
  end

  def import_params
    params.require(:university_organization_import)
          .permit(:file)
  end
end
