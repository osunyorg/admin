class Admin::Communication::Extranets::Documents::ApplicationController < Admin::Communication::Extranets::ApplicationController
  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_library), admin_communication_extranet_documents_path
  end
end