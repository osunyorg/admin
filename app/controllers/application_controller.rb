class ApplicationController < ActionController::Base
  include WithContext

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end
end
