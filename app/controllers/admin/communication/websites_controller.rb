class Admin::Communication::WebsitesController < Admin::Communication::ApplicationController
  load_and_authorize_resource class: Communication::Website

  def index
    @websites = current_university.communication_websites
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
    @website.university = current_university
    if @website.save
      redirect_to [:admin, @website], notice: "Site was successfully created."
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @website.update(website_params)
      redirect_to [:admin, @website], notice: "Site was successfully updated."
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @website.destroy
    redirect_to admin_communication_websites_url, notice: "Site was successfully destroyed."
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website.model_name.human(count: 2), admin_communication_websites_path
    breadcrumb_for @website
  end

  def website_params
    params.require(:communication_website).permit(:name, :domain, :repository, :access_token)
  end
end
