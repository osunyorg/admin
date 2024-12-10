class Api::Osuny::Communication::Websites::ApplicationController < Api::Osuny::ApplicationController
  before_action :load_website

  protected

  def load_website
    @website = current_university.websites.find params[:website_id]
  end

  def website
    @website
  end
end
