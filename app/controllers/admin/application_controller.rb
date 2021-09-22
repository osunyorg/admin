class Admin::ApplicationController < ApplicationController
  layout 'admin/layouts/application'

  before_action :authenticate_user!
  before_action :set_locale

  protected

  def breadcrumb
    add_breadcrumb t('dashboard'), :admin_root_path
  end

  def short_breadcrumb
    @menu_collapsed = true
    add_breadcrumb t('dashboard'), :admin_root_path
    add_breadcrumb '...'
  end

  def breadcrumb_for(object, **options)
    return unless object
    object.persisted? ? add_breadcrumb(object, [:admin, object, options])
                      : add_breadcrumb('Créer')
  end

  def set_locale
    return unless current_user
    return unless current_user.language
    I18n.locale = current_user.language.iso_code
  end
end
