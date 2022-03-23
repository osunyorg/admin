class Admin::University::OrganizationsController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Organization,
                              through: :current_university,
                              through_association: :organizations

  def index
    @organizations = @organizations.ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @organization.university = current_university
    if @organization.save_and_sync()
      redirect_to admin_university_organization_path(@organization),
                  notice: t('admin.successfully_created_html', model: @organization.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update_and_sync(organization_params)
      redirect_to admin_university_organization_path(@organization),
                  notice: t('admin.successfully_updated_html', model: @organization.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @organization.destroy_and_sync
    redirect_to admin_university_organizations_url,
                notice: t('admin.successfully_destroyed_html', model: @organization.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  University::Organization.model_name.human(count: 2),
                    admin_university_organizations_path
    breadcrumb_for @organization
  end

  def organization_params
    params.require(:university_organization)
          .permit(
            :name, :long_name, :slug, :description, :active, :sirene, :kind,
            :address, :zipcode, :city, :country,
            :url, :phone, :email, :logo, :logo_delete
          )
  end
end
