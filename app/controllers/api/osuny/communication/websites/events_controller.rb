class Api::Osuny::Communication::Websites::EventsController < Api::Osuny::Communication::Websites::ApplicationController

  # TODO create
  def import
    importer = Importers::Api::Osuny::Communication::Website::Agenda::Event
    importer.new  university: current_university,
                  website: website,
                  params: params[:event]
    render json: :ok
  end
end
