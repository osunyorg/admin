class Admin::Features::Websites::SitesController < Admin::Features::Websites::ApplicationController
  load_and_authorize_resource class: Features::Websites::Site

  def index
    @sites = current_university.features_websites_sites
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
  end

  def create
    @site.university = current_university
    if @site.save
      redirect_to [:admin, @site], notice: "Site was successfully created."
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @site.update(site_params)
      redirect_to [:admin, @site], notice: "Site was successfully updated."
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @site.destroy
    redirect_to admin_features_websites_sites_url, notice: "Site was successfully destroyed."
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Features::Websites::Site.model_name.human(count: 2), admin_features_websites_sites_path
    if @site
      @site.persisted?  ? add_breadcrumb(@site, [:admin, @site])
                        : add_breadcrumb('Créer')
    end
  end

  def site_params
    params.require(:features_websites_site).permit(:name, :domain)
  end
end
