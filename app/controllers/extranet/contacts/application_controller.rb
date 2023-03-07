class Extranet::Contacts::ApplicationController < Extranet::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_contacts)
  end
end