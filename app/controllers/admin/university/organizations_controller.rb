class Admin::University::OrganizationsController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Organization,
                              through: :current_university,
                              through_association: :organizations

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @organizations = @organizations.filter_by(params[:filters], current_language)
                                   .ordered(current_language)
    @feature_nav = 'navigation/admin/university/organizations'

    respond_to do |format|
      format.html {
        @organizations = @organizations.page(params[:page])
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
                                       .search_by_siren_or_name(@term, current_language)
                                       .ordered(current_language)
  end

  def show
    breadcrumb
  end

  def new
    @categories = categories
    breadcrumb
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @organization.save
      redirect_to admin_university_organization_path(@organization),
                  notice: t('admin.successfully_created_html', model: @organization.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to admin_university_organization_path(@organization),
                  notice: t('admin.successfully_updated_html', model: @organization.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @organization.destroy
    redirect_to admin_university_organizations_url,
                notice: t('admin.successfully_destroyed_html', model: @organization.to_s_in(current_language))
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
            :active, :siren, :kind, :address, :zipcode, :city, :country, :phone, :email, category_ids: [],
            localizations_attributes: [
              :id, :name, :long_name, :slug, :meta_description, :summary, :text,
              :address_name, :address_additional,
              :url, :linkedin, :twitter, :mastodon,
              :logo, :logo_delete, :logo_infos,
              :logo_on_dark_background, :logo_on_dark_background_delete, :logo_on_dark_background_infos,
              :shared_image, :shared_image_delete,
              :language_id
            ]
          )
  end

  def categories
    current_university.organization_categories
                      .ordered
  end
end
