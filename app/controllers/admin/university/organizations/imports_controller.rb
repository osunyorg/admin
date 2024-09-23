class Admin::University::Organizations::ImportsController < Admin::University::ApplicationController
  load_and_authorize_resource class: Import,
                              through: :current_university,
                              through_association: :imports

  def index
    @imports = @imports.kind_organizations
                       .filter_by(params[:filters], current_language)
                       .ordered(current_language)
                       .page(params[:page])
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
    @import.kind = :organizations
    @import.user = current_user
    if @import.save
      redirect_to admin_university_organizations_import_path(@import),
                  notice: t('admin.successfully_created_html', model: @import.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  University::Organization.model_name.human(count: 2),
                    admin_university_organizations_path
    add_breadcrumb  Import.model_name.human(count: 2),
                    admin_university_organizations_imports_path
    return unless @import
    @import.persisted?  ? add_breadcrumb(@import, admin_university_organizations_import_path(@import))
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
