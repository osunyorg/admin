class Admin::VueI18nController < Admin::ApplicationController
  layout false

  def index
    render json: I18n.t('vue')
  end
end
