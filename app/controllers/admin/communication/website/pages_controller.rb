class Admin::Communication::Website::PagesController < Admin::Communication::Website::ApplicationController
  def index
    @pages = @website.pages
    breadcrumb
  end

  def show
    id = "#{params[:id]}.html"
    @page = Communication::Website::Page.find(id, @website)
    breadcrumb
    add_breadcrumb @page
  end

  def new
    @page.website = @website
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @page.university = current_university
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
    add_breadcrumb Communication::Website::Page.model_name.human(count: 2), admin_communication_website_pages_path
    # breadcrumb_for @page
  end

  def page_params
    params.require(:communication_website_page)
          .permit(:university_id, :communication_website_id, :title,
            :description, :about_type, :about_id, :slug, :published_at,
            :parent_id)
  end
end
