class Extranet::ApplicationController < ApplicationController
  layout 'extranet/layouts/application'

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end

  def about
    current_extranet.about || current_university
  end
end
