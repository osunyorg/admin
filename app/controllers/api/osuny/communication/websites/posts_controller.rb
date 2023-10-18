class Api::Osuny::Communication::Websites::PostsController < Api::Osuny::ApplicationController
  skip_before_action :verify_authenticity_token, only: :import
  before_action :verify_app_token, only: :import

  def import
    Importers::Api::Osuny::Communication::Website::Post.new university: current_university,
                                                            website: website,
                                                            params: params[:post]
    render json: :ok
  end

end
