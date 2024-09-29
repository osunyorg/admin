module ApplicationController::WithDomain
  extend ActiveSupport::Concern

  included do
    helper_method :current_university
    helper_method :current_extranet
    helper_method :current_extranet_l10n
    helper_method :current_context
    helper_method :current_mode
  end

  def current_university
    @current_university ||= begin
      current_extranet.present? ? current_extranet.university
                                : University.with_host(request.host)
    end
  end

  def current_extranet
    @current_extranet ||= Communication::Extranet.with_host(request.host)
  end

  def current_extranet_l10n
    @current_extranet_l10n ||= current_extranet.best_localization_for(current_language)
  end


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

  def current_mode
    current_extranet.present? ? 'extranet'
                              : 'university'
  end
end
