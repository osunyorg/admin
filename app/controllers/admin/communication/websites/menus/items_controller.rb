class Admin::Communication::Websites::Menus::ItemsController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource :menu,
                              class: Communication::Website::Menu,
                              id_param: :menu_id,
                              through: :website
  load_and_authorize_resource class: Communication::Website::Menu::Item,
                              through: :menu

  before_action :redirect_to_correct_language, only: :show

  def index
    redirect_to [:admin, @menu]
  end

  def reorder
    parent_id = params[:parentId].blank? ? nil : params[:parentId]
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      item = @menu.items.find(id)
      item.update_columns parent_id: parent_id,
                          position: index + 1
    end
    @menu.sync_with_git
  end

  def show
    @children = @item.children.ordered
    breadcrumb
  end

  def children
    if request.xhr?
      @item = @menu.items.find(params[:id])
      @children = @item.children.ordered
    else
      redirect_to admin_communication_website_menu_path(@menu)
    end
  end

  def kind_switch
    return unless request.xhr?
    @kind = params[:kind]
    return if @kind.blank?
    @collection = Communication::Website::Menu::Item.collection_for(@kind, @website)
  end

  def new
    @item.menu = @menu
    @item.website = @website
    @item.parent = @menu.items.find_by(id: params[:parent_id])
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @menu.stop_automatism!
    @item.menu = @menu
    @item.website = @website
    if @item.save
      redirect_to redirect_path(@item),
                  notice: t('admin.successfully_created_html', model: @item.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @menu.stop_automatism!
    if @item.update(item_params)
      redirect_to redirect_path(@item),
                  notice: t('admin.successfully_updated_html', model: @item.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu.stop_automatism!
    @item.destroy
    redirect_to admin_communication_website_menu_path(@menu),
                notice: t('admin.successfully_destroyed_html', model: @item.to_s)
  end

  protected

  def redirect_to_correct_language
    if @menu.language != current_language
      correct_menu = @website.menus.find_by(language_id: current_language.id, identifier: @menu.identifier)
      if correct_menu.present?
        redirect_to admin_communication_website_menu_path(correct_menu)
      else
        # Here, we should redirect to confirm website localization but menus are not localizable so we just redirect to the index page.
        redirect_to admin_communication_website_menus_path
      end
    end
  end

  def redirect_path(item)
    item.parent.nil?  ? admin_communication_website_menu_path(item.menu)
                      : admin_communication_website_menu_item_path(id: item.parent)
  end

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Menu.model_name.human(count: 2),
                    admin_communication_website_menus_path
    breadcrumb_for @menu
    @item.ancestors.each do |ancestor|
      breadcrumb_for ancestor, menu_id: @menu.id
    end
    breadcrumb_for @item, menu_id: @menu.id
  end

  def item_params
    params.require(:communication_website_menu_item)
          .permit(:title, :kind, :url, :should_open_new_tab, :parent_id, :about_type, :about_id)
          .merge(university_id: current_university.id)
  end
end
