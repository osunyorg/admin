class ApplicationController < ActionController::Base
  include WithErrors
  include WithLocale
  include WithDomain

  before_action :authenticate_user!

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end
end
