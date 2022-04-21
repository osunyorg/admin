class ApplicationController < ActionController::Base
  include WithErrors
  include WithLocale
  include WithDomain

  before_action :ensure_university, :authenticate_user!

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end

  private

  def ensure_university
    render_forbidden unless current_university
  end
end
