class HomeController < ApplicationController
  def index
    redirect_to admin_root_path unless current_extranet
  end
end
