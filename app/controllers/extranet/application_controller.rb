class Extranet::ApplicationController < ApplicationController

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end
end
