class Extranet::StyleController < Extranet::ApplicationController
  def index
    render body: current_extranet.css, content_type: 'text/css'
  end
end