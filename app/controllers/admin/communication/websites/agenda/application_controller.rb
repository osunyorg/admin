class Admin::Communication::Websites::Agenda::ApplicationController < Admin::Communication::Websites::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb  @website.feature_agenda_name(current_language), 
                    admin_communication_website_agenda_events_path
  end
end
