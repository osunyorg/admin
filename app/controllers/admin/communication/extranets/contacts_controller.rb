class Admin::Communication::Extranets::ContactsController < Admin::Communication::Extranets::ApplicationController
  def index
    @persons = current_university.people.ordered.page params[:persons_page]
    @organizations = current_university.organizations.ordered.page params[:organizations_page]
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_contacts)
  end

  def connect
    load_object
    @extranet.connect @object
    redirect_back(fallback_location: admin_communication_extranet_contacts_path(@extranet))
  end

  def disconnect
    load_object
    @extranet.disconnect @object
    redirect_back(fallback_location: admin_communication_extranet_contacts_path(@extranet))
  end


  protected

  def load_object
    object_type = params[:objectType]
    object_id = params[:objectId]
    @object = object_type.constantize.find object_id
  end
end