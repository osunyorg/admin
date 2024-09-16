module ApplicationController::WithLocale
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale

    helper_method :current_interface_language
    helper_method :current_language
  end

  def current_interface_language
    @current_interface_language ||= Language.find_by(iso_code: I18n.locale.to_s)
  end

  protected

  def switch_locale(&action)
    locale = LocaleService.locale(current_user, request.env['HTTP_ACCEPT_LANGUAGE'])
    I18n.with_locale(locale, &action)
  end

  def current_language
    @current_language ||= current_university.best_language_for(params[:lang])
  end

  def default_url_options
    options = {}
    options[:lang] = current_language
    options
  end
end
