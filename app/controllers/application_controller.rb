class ApplicationController < ActionController::Base
  include WithDomain
  include WithErrors
  include WithFeatures
  include WithLocale
  include WithMaintenance

  before_action :ensure_university, :authenticate_user!

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end

  private

  def current_ability
    @current_ability ||= Ability.for(current_user)
  end

  def ensure_university
    render_forbidden unless current_university
  end
end
