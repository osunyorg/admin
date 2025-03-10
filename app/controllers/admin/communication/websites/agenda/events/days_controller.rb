class Admin::Communication::Websites::Agenda::Events::DaysController < Admin::Communication::Websites::Agenda::ApplicationController
  load_and_authorize_resource :event,
                              class: Communication::Website::Agenda::Event,
                              through: :website,
                              param_name: :event_id
  load_and_authorize_resource class: Communication::Website::Agenda::Event::Day,
                              through: :event

  def static
    @l10n = @day
    @about = @day
    partial = @about.template_static
    render  partial, 
            layout: false, 
            content_type: "text/plain; charset=utf-8"
  end
end