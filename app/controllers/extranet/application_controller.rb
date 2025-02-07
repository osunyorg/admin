class Extranet::ApplicationController < ApplicationController
  layout 'extranet/layouts/application'

  before_action :redirect_if_no_extranet!,
                :redirect_if_language_not_active!,
                :authorize_extranet_access!

  def breadcrumb
    add_breadcrumb t('home'), extranet_root_path
  end

  protected

  def redirect_if_no_extranet!
    redirect_to admin_root_path(lang: current_university.default_language) unless current_extranet
  end

  def redirect_if_language_not_active!
    redirect_to root_path(lang: nil) unless current_extranet.active_languages.include?(current_language)
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
    current_extranet.feature_alumni? && current_extranet.alumni.find_by(id: current_user.person&.id).present?
  end

  def user_is_contact
    current_extranet.feature_contacts? && current_extranet.connected_people.find_by(id: current_user.person&.id).present?
  end

  def default_url_options
    options = {}
    options[:lang] = current_language
    options
  end

end
