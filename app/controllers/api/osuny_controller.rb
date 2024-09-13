class Api::OsunyController < Api::Osuny::ApplicationController
  def redirect_to_v1
    redirect_to '/api/osuny/v1'
  end

  def index
  end
end
