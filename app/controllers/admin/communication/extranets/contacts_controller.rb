class Admin::Communication::Extranets::ContactsController < Admin::Communication::Extranets::ApplicationController
  def index
    @people = current_university.people.ordered
    @organizations = current_university.organizations.ordered
    respond_to do |format|
      format.html {
        @people = @people.page params[:persons_page]
        @organizations = @organizations.page params[:organizations_page]
      }
      format.xlsx {
        # could be 2 differents controllers in Contacts/People & Contacts/Organizations, each with an index export
        @export = params['export']
        filename = "#{@export}-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
        render @export
      }
    end


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
