class Admin::Communication::Website::IndexPagesController < Admin::Communication::Website::ApplicationController
  before_action :get_index_page, :ensure_abilities, only: [:edit, :update]

  def index
    authorize! :read, Communication::Website::IndexPage
    breadcrumb
    @kinds = Communication::Website::IndexPage.kinds
  end

  def edit
    breadcrumb
    add_breadcrumb t("communication.website.index_pages.default.#{@index_page.kind}.title")
  end

  def update
    # TODO: sync
    # if @index_page.update_and_sync(index_page_params)
    if @index_page.update(index_page_params)
      redirect_to admin_communication_website_indexes_path(@website), notice: t('admin.successfully_updated_html', model: Communication::Website::IndexPage.model_name.human)
    else
      breadcrumb
      add_breadcrumb t("communication.website.index_pages.default.#{@index_page.kind}.title")
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  def get_index_page
    @index_page = @website.index_for(params[:kind])
  end

  def ensure_abilities
    authorize! :update, @index_page
  end

  def breadcrumb
    super
    add_breadcrumb Communication::Website::IndexPage.model_name.human(count: 2), admin_communication_website_indexes_path(@website)
  end


  def index_page_params
    params.require(:communication_website_index_page)
          .permit(
            :title, :description, :text, :path, :featured_image, :featured_image_delete,
            :featured_image_infos, :featured_image_alt
          )
          .merge(university_id: current_university.id)
  end
end
