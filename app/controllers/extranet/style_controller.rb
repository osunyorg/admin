class Extranet::StyleController < Extranet::ApplicationController
  skip_before_action :authenticate_user!, :authorize_extranet_access!
  
  def index
    render body: current_extranet.css, content_type: 'text/css'
  end
end
