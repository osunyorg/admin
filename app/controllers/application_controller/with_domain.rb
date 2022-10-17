module ApplicationController::WithDomain
  extend ActiveSupport::Concern

  included do
    def current_extranet
      @current_extranet ||= Communication::Extranet.with_host(request.host)
    end
    helper_method :current_extranet

    def current_university
      @current_university ||= begin
        current_extranet.present? ? current_extranet.university
                                  : University.with_host(request.host)
      end
    end
    helper_method :current_university

    def current_context
      @current_context ||= begin
        # Take the extranet as a context
        context = current_extranet
        # If no extranet, university becomes the context
        context ||= current_university
        # Return context, might be nil if neither extranet nor university
        context
      end
    end
    helper_method :current_context

    def current_mode
      current_extranet.present? ? 'extranet'  : 'university'
    end
    helper_method :current_mode
  end
end
