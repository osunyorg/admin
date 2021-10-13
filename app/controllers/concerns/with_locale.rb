module WithLocale
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale
  end

  protected

  def switch_locale(&action)
    locale = LocaleService.locale(current_user, request.env['HTTP_ACCEPT_LANGUAGE'])
    I18n.with_locale(locale, &action)
  end
end
