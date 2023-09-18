class Api::Osuny::ApplicationController < Api::ApplicationController
  protected

  def verify_app_token
    app = current_university.apps.find_by(access_key: params[:access_key], 
                                          secret_key: params[:secret_key])
    raise_403_unless app
  end
end