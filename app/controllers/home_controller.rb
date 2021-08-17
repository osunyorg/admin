class HomeController < ApplicationController
  def index
    redirect_to '/admin' if is_university?
  end
end
