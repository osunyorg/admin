class Admin::Administration::LocationsController < Admin::Administration::ApplicationController
  load_and_authorize_resource class: Administration::Location,
                              through: :current_university

  include Admin::Localizable
  include Admin::HasStaticAction
  
  def index
    @locations = @locations.ordered(current_language)
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
    @location.language_id = current_language.id
    if @location.save
      redirect_to [:admin, @location],
                  notice: t('admin.successfully_created_html', model: @location.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @location.update(location_params)
      redirect_to [:admin, @location],
                  notice: t('admin.successfully_updated_html', model: @location.to_s_in(current_language))
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    redirect_to admin_education_locations_url,
                notice: t('admin.successfully_destroyed_html', model: @location.to_s_in(current_language))
  end

  private

  def breadcrumb
    super
    add_breadcrumb Administration::Location.model_name.human(count: 2), admin_administration_locations_path
    breadcrumb_for @location
  end

  def location_params
    params.require(:administration_location)
          .permit(
            :address, :zipcode, :city, :country, :phone, 
            school_ids: [], program_ids: [],
            localizations_attributes: [
              :id, :language_id,
              :name, :address_additional, :address_name, :url, :summary, :slug, 
              :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end
end
