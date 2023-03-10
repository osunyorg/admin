class Extranet::ApplicationController < ApplicationController
  layout 'extranet/layouts/application'

  before_action :redirect_if_no_extranet!,
                :authorize_extranet_access!

  def breadcrumb
    add_breadcrumb t('home'), root_path
  end

  def about
    current_extranet.about || current_university
  end

  private

  def redirect_if_no_extranet!
    redirect_to admin_root_path unless current_extranet
  end

  def authorize_extranet_access!
    raise CanCan::AccessDenied unless user_is_authorized?
  end

  def user_is_authorized?
    user_is_more_than_visitor || user_is_alumnus || user_is_contact
  end

  def user_is_more_than_visitor
    !current_user.visitor?
  end

  def user_is_alumnus
    about.alumni.find_by(id: current_user.person&.id).present?
  end

  def user_is_contact
    current_extranet.connected_persons.find_by(id: current_user.person&.id).present?
  end

end
