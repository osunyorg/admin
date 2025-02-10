class Extranet::Contacts::ApplicationController < Extranet::ApplicationController
  before_action :redirect_if_feature_disabled

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_contacts), contacts_root_path
  end

  def redirect_if_feature_disabled
    redirect_to extranet_root_path unless current_extranet.feature_contacts?
  end
end