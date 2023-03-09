class Admin::Communication::Extranets::FilesController < Admin::Communication::Extranets::ApplicationController
  load_and_authorize_resource class: Communication::Extranet::File, through: :extranet

  def index
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    @file.extranet = @extranet
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @file.extranet = @extranet
    if @file.save
      redirect_to admin_communication_extranet_file_path(@file), notice: t('admin.successfully_created_html', model: @file.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @file.update(file_params)
      redirect_to admin_communication_extranet_file_path(@file), notice: t('admin.successfully_updated_html', model: @file.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @file.destroy
    redirect_to admin_communication_extranet_files_url, notice: t('admin.successfully_destroyed_html', model: @file.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_files), admin_communication_extranet_files_path
    breadcrumb_for @file
  end

  def file_params
    params.require(:communication_extranet_file)
    .permit(
      :name, :published, :published_at, :slug,
      :file, :file_delete
    )
    .merge(
      university_id: current_university.id
    )
  end
end