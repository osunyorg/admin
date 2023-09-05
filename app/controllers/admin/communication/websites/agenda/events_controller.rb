class Admin::Communication::Websites::Agenda::EventsController < Admin::Communication::Websites::Agenda::ApplicationController
  load_and_authorize_resource class: Communication::Website::Agenda::Event, 
                              through: :website

  def index
    @events = apply_scopes(@events).for_language(current_website_language).ordered.page params[:page]
    breadcrumb
  end

  def publish
    @event.published = true
    @event.save_and_sync
    redirect_back fallback_location: admin_communication_website_agenda_event_path(@event),
                  notice: t('admin.communication.website.publish.notice')
  end

  def show
    breadcrumb
  end

  def static
    @about = @event
    render layout: false
  end

  def new
    @event.website = @website
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @event.website = @website
    @event.add_photo_import params[:photo_import]
    if @event.save_and_sync
      redirect_to admin_communication_website_agenda_event_path(@event), notice: t('admin.successfully_created_html', model: @event.to_s)
    else
      byebug
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @event.add_photo_import params[:photo_import]
    if @event.update_and_sync(event_params)
      redirect_to admin_communication_website_agenda_event_path(@event), notice: t('admin.successfully_updated_html', model: @event.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    redirect_to [:admin, @event.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @event.to_s)
  end

  def destroy
    @event.destroy
    redirect_to admin_communication_website_agenda_events_url, notice: t('admin.successfully_destroyed_html', model: @event.to_s)
  end
  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Agenda::Event.model_name.human(count: 2),
                    admin_communication_website_agenda_events_path
    breadcrumb_for @event
  end

  def event_params
    params.require(:communication_website_agenda_event)
    .permit(
      :title, :meta_description, :summary, :published, :slug,
      :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit
    )
    .merge(
      university_id: current_university.id,
      language_id: current_website_language.id
    )
  end
end