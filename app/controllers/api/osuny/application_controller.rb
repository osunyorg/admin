class Api::Osuny::ApplicationController < Api::ApplicationController
  protected

  def verify_app_token
    token = params[:token]
    app = current_university.apps.find_by(token: token)
    raise_403_unless app
  end
end