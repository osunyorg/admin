class Api::Osuny::Communication::Websites::Agenda::EventsController < Api::Osuny::Communication::Websites::ApplicationController
  before_action :build_event, only: :create
  before_action :load_event, only: [:show, :update, :destroy]

  before_action :load_migration_identifier, only: [:create, :update]
  before_action :ensure_same_migration_identifier, only: :update

  def index
    @events = website.events.includes(:localizations)
  end

  def show
  end

  def create
    if @event.save
      render :show, status: :created
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render :show
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  def upsert
    events_params = params[:events] || []
    every_event_has_migration_identifier = events_params.all? { |event_params|
      event_params[:migration_identifier].present?
    }
    unless every_event_has_migration_identifier
      render_on_missing_migration_identifier
      return
    end

    permitted_events_params = events_params.map { |unpermitted_params|
      event_params_for_upsert(unpermitted_params)
    }
    @successfully_created_events = []
    @successfully_updated_events = []
    @invalid_events_with_index = []
    permitted_events_params.each_with_index do |permitted_event_params, index|
      event = website.events.find_by(migration_identifier: permitted_event_params[:migration_identifier])
      if event.present?
        if event.update(permitted_event_params)
          @successfully_updated_events << event
        else
          @invalid_events_with_index << { event: event, index: index }
        end
      else
        event = website.events.build(permitted_event_params)
        if event.save
          @successfully_created_events << event
        else
          @invalid_events_with_index << { event: event, index: index }
        end
      end
    end

    status = @invalid_events_with_index.any? ? :unprocessable_entity : :ok
    render 'upsert', status: status
  end

  def destroy
    @event.destroy
    head :no_content
  end

  protected

  def build_event
    @event = website.events.build
    @event.assign_attributes(event_params)
  end

  def load_event
    @event = website.events.find(params[:id])
  end

  def load_migration_identifier
    @migration_identifier = event_params[:migration_identifier]
    render_on_missing_migration_identifier unless @migration_identifier.present?
  end

  def ensure_same_migration_identifier
    if @event.migration_identifier != @migration_identifier
      render json: { error: 'Migration identifier does not match' }, status: :unprocessable_entity
    end
  end

  def l10n_permitted_keys
    [
      :migration_identifier, :language, :title, :meta_description,
      :published, :published_at, :slug, :subtitle, :summary, :text, :_destroy,
      featured_image: [:url, :alt, :credit, :_destroy],
      blocks: [:migration_identifier, :template_kind, :title, :position, :published, :html_class, data: {}]
    ]
  end

  def event_params
    @event_params ||= begin
      permitted_params = params.require(:event)
                          .permit(
                            :migration_identifier, :from_day, :from_hour, :to_day, :to_hour, :time_zone,
                            :created_by_id, :parent_id, localizations: {}
                          ).merge(
                            university_id: current_university.id,
                            communication_website_id: website.id
                          )
      set_l10n_attributes(permitted_params, @event) if permitted_params[:localizations].present?
      permitted_params
    end
  end

  def event_params_for_upsert(event_params)
    permitted_params = event_params
                          .permit(
                            :migration_identifier, :from_day, :from_hour, :to_day, :to_hour, :time_zone,
                            :created_by_id, :parent_id, localizations: {}
                          ).merge(
                            university_id: current_university.id,
                            communication_website_id: website.id
                          )
    event = website.events.find_by(migration_identifier: permitted_params[:migration_identifier])
    permitted_params[:id] = event.id if event.present?
    set_l10n_attributes(permitted_params, event) if permitted_params[:localizations].present?
    permitted_params
  end
end
