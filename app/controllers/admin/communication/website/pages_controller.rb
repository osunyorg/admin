class Admin::Communication::Website::PagesController < Admin::Communication::Website::ApplicationController
  load_and_authorize_resource class: Communication::Website::Page

  def index
    @pages = @website.pages.ordered
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
    @page.university = current_university
    @page.website = @website
    if @page.save
      redirect_to admin_communication_website_page_path(@page), notice: "Page was successfully created."
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @page.update(page_params)
      redirect_to admin_communication_website_page_path(@page), notice: "Page was successfully updated."
    else
      breadcrumb
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to admin_communication_website_url, notice: "Page was successfully destroyed."
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Page.model_name.human(count: 2),
                    admin_communication_website_pages_path
    breadcrumb_for @page
  end

  def page_params
    params.require(:communication_website_page)
          .permit(:university_id, :communication_website_id, :title,
            :description, :text, :about_type, :about_id, :slug, :published,
            :parent_id)
  end
end
