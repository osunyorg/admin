module ApplicationController::WithContext
  extend ActiveSupport::Concern

  included do

    def current_university
        @current_university ||= University.with_host(request.host)
    end
    helper_method :current_university

    def current_website
        @current_website ||= Features::Websites::Site.with_host(request.host)
    end
    helper_method :current_website

  end
end
