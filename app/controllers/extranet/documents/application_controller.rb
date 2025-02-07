class Extranet::Documents::ApplicationController < Extranet::ApplicationController
  before_action :redirect_if_feature_disabled

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_documents), documents_root_path
  end

  def redirect_if_feature_disabled
    redirect_to extranet_root_path unless current_extranet.feature_documents?
  end
end