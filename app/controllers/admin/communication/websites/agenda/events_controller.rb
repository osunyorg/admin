class Admin::Communication::Websites::Agenda::EventsController < Admin::Communication::Websites::Agenda::ApplicationController
  load_and_authorize_resource class: Communication::Website::Agenda::Event, through: :website

  def index
    @events = apply_scopes(@events).for_language(current_website_language).ordered.page params[:page]
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Agenda::Event.model_name.human(count: 2),
                    admin_communication_website_agenda_events_path
    breadcrumb_for @event
  end
end