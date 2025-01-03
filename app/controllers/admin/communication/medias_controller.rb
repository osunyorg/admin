class Admin::Communication::MediasController < Admin::Communication::Medias::ApplicationController
  load_and_authorize_resource class: Communication::Media,
                              through: :current_university

  include Admin::Localizable

  def index
    @medias = @medias.filter_by(params[:filters], current_language)
                      .ordered(current_language)
                      .page(params[:page])
    breadcrumb
    @feature_nav = 'navigation/admin/communication/medias'
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('admin.subnav.settings')
  end

  def create
    if @media.save
      redirect_to [:admin, @media], notice: t('admin.successfully_created_html', model: @media.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @media.update(extranet_params)
      redirect_to [:admin, @media], notice: t('admin.successfully_updated_html', model: @media.to_s_in(current_language))
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @media.destroy
    redirect_to admin_communication_websites_url, notice: t('admin.successfully_destroyed_html', model: @media.to_s_in(current_language))
  end
end