class Admin::University::OrganizationsController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Organization,
                              through: :current_university,
                              through_association: :organizations

  has_scope :for_search_term
  has_scope :for_category
  has_scope :for_kind

  def index
    @organizations = apply_scopes(@organizations).ordered

    respond_to do |format|
      format.html {
        @organizations = @organizations.page params[:page]
        @categories = current_university.organization_categories.ordered.page(params[:categories_page])
        breadcrumb
      }
      format.xlsx {
        filename = "organizations-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
      }
    end
  end

  def search
    @term = params[:term].to_s
    @organizations = current_university.organizations
                                        .search_by_siren_or_name(@term)
                                        .ordered
  end

  def show
    breadcrumb
  end

  def static
    @about = @organization
    @website = @organization.websites&.first
    render layout: false
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
            :name, :long_name, :slug, :meta_description, :summary, :active, :siren, :kind,
            :address, :address_name, :address_additional, :zipcode, :city, :country, :text,
            :url, :phone, :email, :linkedin, :twitter, :mastodon,
            :logo, :logo_delete, :logo_infos,
            :logo_on_dark_background, :logo_on_dark_background_delete, :logo_on_dark_background_infos,
            category_ids: []
          )
  end
end
