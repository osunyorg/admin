class Admin::Communication::Websites::Agenda::EventsController < Admin::Communication::Websites::Agenda::ApplicationController
  load_and_authorize_resource class: Communication::Website::Agenda::Event,
                              through: :website

  include Admin::HasStaticAction
  include Admin::Localizable

  # Allow to override the default load_filters from Admin::Filterable
  before_action :load_filters, only: :index

  has_scope :for_search_term
  has_scope :for_category

  def index
    @events = apply_scopes(@events).tmp_original # TODO L10N : To remove
                                  .ordered_desc
                                  .page(params[:page])
    @feature_nav = 'navigation/admin/communication/website/agenda'
    breadcrumb
  end

  def publish
    @l10n.publish!
    @event.sync_with_git
    redirect_back fallback_location: admin_communication_website_agenda_event_path(@event),
                  notice: t('admin.communication.website.publish.notice')
  end

  def show
    breadcrumb
  end

  def new
    @categories = categories
    breadcrumb
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @event.website = @website
    @event.add_photo_import params[:photo_import]
    if @event.save_and_sync
      redirect_to admin_communication_website_agenda_event_path(@event),
                  notice: t('admin.successfully_created_html', model: @event.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @event.add_photo_import params[:photo_import]
    if @event.update_and_sync(event_params)
      redirect_to admin_communication_website_agenda_event_path(@event),
                  notice: t('admin.successfully_updated_html', model: @event.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    redirect_to [:admin, @event.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @event.to_s_in(current_language))
  end

  def destroy
    @event.destroy
    redirect_to admin_communication_website_agenda_events_url,
                notice: t('admin.successfully_destroyed_html', model: @event.to_s_in(current_language))
  end
  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Agenda::Event.model_name.human(count: 2),
                    admin_communication_website_agenda_events_path
    breadcrumb_for @event
  end

  def categories
    @website.agenda_categories
            .for_language(current_language)
            .ordered
  end

  def load_filters
    @filters = ::Filters::Admin::Communication::Websites::Agenda::Events.new(
        current_user,
        @website,
        current_language
      ).list
  end

  def event_params
    params.require(:communication_website_agenda_event)
    .permit(
      :from_day, :from_hour, :to_day, :to_hour, :time_zone,
      category_ids: [],
      localizations_attributes: [
        :id, :title, :subtitle, :meta_description, :summary, :text,
        :published, :published_at, :slug, 
        :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
        :shared_image, :shared_image_delete, :shared_image_infos,
        :language_id
      ]
    )
    .merge(
      university_id: current_university.id,
      language_id: current_language.id
    )
  end
end