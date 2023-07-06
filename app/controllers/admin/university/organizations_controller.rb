class Admin::University::OrganizationsController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::Organization,
                              through: :current_university,
                              through_association: :organizations

  has_scope :for_search_term
  has_scope :for_category
  has_scope :for_kind

  def index
    @organizations = apply_scopes(@organizations)
                      .for_language_id(current_university.default_language_id)
                      .ordered

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
    language = Language.find_by(iso_code: params[:lang])
    @organizations = current_university.organizations
                                        .search_by_siren_or_name(@term)
                                        .ordered
    @organizations = @organizations.joins(:language)
                                    .where(languages: { 
                                      iso_code: language.iso_code 
                                    }) if language.present?
  end

  def show
    breadcrumb
  end

  def in_language
    language = Language.find_by!(iso_code: params[:lang])
    translation = @organization.find_or_translate!(language)
    if translation.newly_translated
      # There's an attribute accessor named "newly_translated" that we set to true
      # when we just created the translation. We use it to redirect to the form instead of the show.
      redirect_to [:edit, :admin, translation.becomes(translation.class.base_class)]
    else
      redirect_to [:admin, translation.becomes(translation.class.base_class)]
    end
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
    if @organization.save
      redirect_to admin_university_organization_path(@organization),
                  notice: t('admin.successfully_created_html', model: @organization.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to admin_university_organization_path(@organization),
                  notice: t('admin.successfully_updated_html', model: @organization.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @organization.destroy
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
