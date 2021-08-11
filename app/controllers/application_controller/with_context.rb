module ApplicationController::WithContext
  extend ActiveSupport::Concern

  included do

    def current_university
      unless @current_university
        @current_university = current_website ? current_website.university
                                              : University.with_host(request.host)
      end
      @current_university
    end
    helper_method :current_university

    def current_website
      @current_website ||= Features::Websites::Site.with_host(request.host)
    end
    helper_method :current_website

  end
end
