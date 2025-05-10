class Admin::Communication::Websites::Agenda::Events::TimeSlotsController < Admin::Communication::Websites::Agenda::ApplicationController
  load_and_authorize_resource :event,
                              class: Communication::Website::Agenda::Event,
                              through: :website,
                              param_name: :event_id
  load_and_authorize_resource class: Communication::Website::Agenda::Event::TimeSlot,
                              through: :event

  include Admin::HasStaticAction
  include Admin::Localizable
end