class ApplicationController < ActionController::Base
  include WithLocale
  include WithUniversity

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end
end
