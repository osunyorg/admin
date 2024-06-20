class Admin::Administration::LocationsController < Admin::Administration::ApplicationController
  load_and_authorize_resource class: Administration::Location,
                              through: :current_university

  include Admin::Translatable

  def index
    @locations = @locations.in_closest_language_id(current_language.id)
                           .ordered
    breadcrumb
  end

  def show
    breadcrumb
  end

  def static
    @about = @location
    @website = @location.websites&.first
    render_as_plain_text
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
                  notice: t('admin.successfully_created_html', model: @location.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @location.update(location_params)
      redirect_to [:admin, @location],
                  notice: t('admin.successfully_updated_html', model: @location.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    redirect_to admin_education_locations_url,
                notice: t('admin.successfully_destroyed_html', model: @location.to_s)
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
            :name, :address, :address_additional, :address_name, :zipcode, :city, :country, 
            :url, :phone, :summary, :slug, 
            :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
            school_ids: [], program_ids: []
          )
          .merge(
            university_id: current_university.id
          )
  end
end
