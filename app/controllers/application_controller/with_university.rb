module ApplicationController::WithUniversity
  extend ActiveSupport::Concern

  included do
    # Raises ActiveRecord::RecordNotFound to prevent access from non-listed hosts
    def current_university
      @current_university ||= University.with_host(request.host)
    end
    helper_method :current_university
  end
end
