class ApplicationController < ActionController::Base
  include WithUniversity

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end
end
