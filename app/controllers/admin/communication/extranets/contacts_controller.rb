class Admin::Communication::Extranets::ContactsController < Admin::Communication::Extranets::ApplicationController
  def index
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_contacts)
  end
end