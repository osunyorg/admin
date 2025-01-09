module ApplicationController::WithErrors
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do |exception|
      render_forbidden
    end

    rescue_from ActionController::RoutingError do |exception|
      render_not_found
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      render_not_found
    end

    rescue_from ActiveStorage::FileNotFoundError do |exception|
      render_not_found
    end

    def raise_403_unless(condition)
      raise CanCan::AccessDenied unless condition
    end

    def raise_404_unless(condition)
      raise ActionController::RoutingError.new('Not Found') unless condition
    end

    def handle_unverified_request
      redirect_back(fallback_location: '/', alert: t('inactivity_alert'))
    end

    def render_not_found
      respond_to do |format|
        format.html { render file: Rails.root.join('public/404.html'), formats: [:html], status: 404, layout: false }
        format.json { render json: { message: "The resource you were looking for doesn't exist." }, status: 404 }
        format.any { head 404 }
      end
    end

    # Used for API. For other contexts, we redirect to the sign-in page via the `authenticate_user!` method.
    def render_unauthorized
      respond_to do |format|
        format.json { render json: { message: "You are not authorized to access this resource." }, status: 401 }
        format.any { head 401 }
      end
    end

    def render_forbidden
      respond_to do |format|
        format.html { render file: Rails.root.join('public/403.html'), formats: [:html], status: 403, layout: false }
        format.json { render json: { message: "You do not have access to this resource." }, status: 403 }
        format.any { head 403 }
      end
    end
  end
end
