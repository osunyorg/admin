class Admin::Communication::Websites::MenusController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Menu, through: :website

  def index
    @menus = @menus.ordered.page(params[:page])
    breadcrumb
  end

  def show
    @items = @menu.items.ordered
    @root_items = @items.root
    breadcrumb
  end

  def new
    @menu.website = @website
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @menu.website = @website
    if @menu.save_and_sync
      redirect_to admin_communication_website_menu_path(@menu), notice: t('admin.successfully_created_html', model: @menu.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @menu.update_and_sync(menu_params)
      redirect_to admin_communication_website_menu_path(@menu), notice: t('admin.successfully_updated_html', model: @menu.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu.destroy_and_sync
    redirect_to admin_communication_website_menus_url, notice: t('admin.successfully_destroyed_html', model: @menu.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Menu.model_name.human(count: 2),
                    admin_communication_website_menus_path
    breadcrumb_for @menu
  end

  def menu_params
    params.require(:communication_website_menu)
          .permit(:website_id, :title, :identifier)
          .merge(university_id: current_university.id)
  end
end
