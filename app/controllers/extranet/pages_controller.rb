class Extranet::PagesController < Extranet::ApplicationController
  skip_before_action :authenticate_user!, :authorize_extranet_access!

  def termes_of_use
  end

  def cookie_policy
  end

  def privacy_policy
  end
end
