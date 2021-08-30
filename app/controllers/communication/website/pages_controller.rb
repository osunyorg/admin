class Communication::Website::PagesController < ApplicationController
  def index
    redirect_to '/admin' if is_university?
    @page = current_website.pages.find_by path: request.path
    if @page
      render :show
    else
      @pages = current_website.pages
    end
  end

  def show
  end
end
