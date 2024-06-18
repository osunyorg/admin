class Api::Osuny::Communication::Websites::EventsController < Api::Osuny::Communication::Websites::ApplicationController
  skip_before_action :verify_authenticity_token, only: :import
  before_action :verify_app_token, only: :import

  def import
    importer = Importers::Api::Osuny::Communication::Website::Agenda::Event
    importer.new  university: current_university,
                  website: website,
                  params: params[:event]
    render json: :ok
  end

end
