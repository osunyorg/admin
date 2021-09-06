module ApplicationController::WithUniversity
  extend ActiveSupport::Concern

  included do
    def current_university
      @current_university ||= University.with_host(request.host)
    end
    helper_method :current_university
  end
end
