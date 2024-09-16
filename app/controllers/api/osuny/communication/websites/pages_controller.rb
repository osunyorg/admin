class Api::Osuny::Communication::Websites::PagesController < Api::Osuny::Communication::Websites::ApplicationController
  # TODO create
  def import
    Importers::Api::Osuny::Communication::Website::Page.new university: current_university,
                                                            website: website,
                                                            params: params[:page]
    render json: :ok
  end
end
