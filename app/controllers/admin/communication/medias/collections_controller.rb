class Admin::Communication::Medias::CollectionsController < Admin::Communication::Medias::ApplicationController
  load_and_authorize_resource class: Communication::Media::Collection,
                              through: :current_university,
                              through_association: :communication_media_collections

  include Admin::Localizable

  def index
    @feature_nav = 'navigation/admin/communication/medias'
    breadcrumb
  end

  def show
    @medias =  @collection.medias
                          .ordered(current_language)
                          .page(params[:page])
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
    if @collection.save
      redirect_to admin_communication_media_collection_path(@collection),
                  notice: t('admin.successfully_created_html', model: @collection.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @collection.update(collection_params)
      redirect_to admin_communication_media_collection_path(@collection),
                  notice: t('admin.successfully_updated_html', model: @collection.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @collection.destroy
    redirect_to admin_communication_media_collections_path,
                notice: t('admin.successfully_destroyed_html', model: @collection.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Media::Collection.model_name.human(count: 2),
                    admin_communication_media_collections_path
    breadcrumb_for @collection
  end

  def collection_params
    params.require(:communication_media_collection)
          .permit(
            localizations_attributes: [
              :id, :name, :alt, :credit, :language_id
            ]
          )
          .merge(university_id: current_university.id)
  end
end
