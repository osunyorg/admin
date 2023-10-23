class Api::Osuny::Communication::Websites::ApplicationController < Api::Osuny::ApplicationController

  protected

  def website
    @website ||= current_university.websites.find params[:website_id]
  end

end
