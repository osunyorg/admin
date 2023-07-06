class Admin::Communication::Extranets::ContactsController < Admin::Communication::Extranets::ApplicationController
  def index
    @people = current_university.people
                                .for_language_id(current_university.default_language_id)
                                .ordered
                                .page(params[:persons_page])
    @organizations = current_university.organizations
                                        .for_language_id(current_university.default_language_id)
                                        .ordered
                                        .page(params[:organizations_page])
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_contacts)
  end

  def export_people
    @people = @extranet.connected_people
                       .for_language_id(current_university.default_language_id)
                       .ordered
    filename = "people-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
    render "admin/university/people/index"
  end

  def export_organizations
    @organizations = @extranet.connected_organizations
                              .for_language_id(current_university.default_language_id)
                              .ordered
    filename = "organizations-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
    render "admin/university/organizations/index"
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

  def toggle
    load_object
    # connect / disconnect
    params[:connection] == 'connect'  ? @extranet.connect(@object)
                                      : @extranet.disconnect(@object)
    head :ok
  end

  protected

  def load_object
    object_type = params[:objectType]
    object_id = params[:objectId]
    @object = object_type.constantize.find object_id
  end
end
