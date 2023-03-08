class Admin::Communication::Extranets::FilesController < Admin::Communication::Extranets::ApplicationController
  def index
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_files)
  end
end