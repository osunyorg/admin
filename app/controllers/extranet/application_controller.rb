class Extranet::ApplicationController < ApplicationController
  layout 'extranet/layouts/application'

  before_action :authorize_extranet_access!

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end

  def about
    current_extranet.about || current_university
  end

  private

  def authorize_extranet_access!
    raise CanCan::AccessDenied if current_user.visitor? && about.alumni.find_by(id: current_user.person&.id).nil?
  end
end
