module ApplicationController::WithContext
  extend ActiveSupport::Concern

  included do

    def current_university
      @current_university ||= current_website ? current_website.university
                                              : University.with_host(request.host)
    end
    helper_method :current_university

    def current_website
      @current_website ||= Features::Websites::Site.with_host(request.host)
    end
    helper_method :current_website

    def is_university?
      @is_university ||= !University.with_host(request.host).nil?
    end
    helper_method :is_university?

    def is_website?
      @is_website ||= !Features::Websites::Site.with_host(request.host).nil?
    end
    helper_method :is_website?

  end
end
