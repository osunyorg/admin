class Api::Osuny::Communication::Websites::ApplicationController < Api::Osuny::ApplicationController

  protected

  def websites
    @websites ||= current_university.websites
  end

  def website
    @website ||= websites.find params[:website_id]
  end
end
