class Admin::Communication::Website::ApplicationController < Admin::Communication::ApplicationController
  load_and_authorize_resource :website, class: Communication::Website

  protected

  def default_url_options
    return {} unless params.has_key? :website_id
    {
      website_id: params[:website_id]
    }
  end
end
