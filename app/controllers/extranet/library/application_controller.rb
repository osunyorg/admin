class Extranet::Library::ApplicationController < Extranet::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_library), library_root_path
  end
end