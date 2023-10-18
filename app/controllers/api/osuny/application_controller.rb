class Api::Osuny::ApplicationController < Api::ApplicationController

  protected

  def verify_app_token
    @app = current_university.apps.find_by(token: request.headers['X-Osuny-Token'])
    raise_403_unless @app
  end

  def website
    @website ||= current_university.websites.find params[:website_id]
  end

end