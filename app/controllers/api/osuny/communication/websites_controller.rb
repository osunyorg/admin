class Api::Osuny::Communication::WebsitesController < Api::ApplicationController

  def index
    @websites = current_university.communication_websites.in_production
  end

end
