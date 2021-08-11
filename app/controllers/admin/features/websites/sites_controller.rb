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
    respond_to do |format|
      if @site.save
        format.html { redirect_to [:admin, @site], notice: "Site was successfully created." }
        format.json { render :show, status: :created, location: [:admin, @site] }
      else
        breadcrumb
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to [:admin, @site], notice: "Site was successfully updated." }
        format.json { render :show, status: :ok, location: [:admin, @site] }
      else
        breadcrumb
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to admin_features_websites_sites_url, notice: "Site was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Features::Websites::Site.model_name.human(count: 2), admin_features_websites_sites_path
    if @site
      if @site.persisted?
        add_breadcrumb @site, [:admin, @site]
      else
        add_breadcrumb 'Créer'
      end
    end
  end

  def site_params
    params.require(:features_websites_site).permit(:name, :domain)
  end
end
