class ApplicationController < ActionController::Base
  include WithErrors
  include WithLocale
  include WithUniversity

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end
end
