class Admin::Communication::Extranets::ContactsController < Admin::Communication::Extranets::ApplicationController
  def index
    @people = current_university.people
                                .ordered(current_language)
                                .page(params[:persons_page])
    @organizations = current_university.organizations
                                        .ordered(current_language)
                                        .page(params[:organizations_page])
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_contacts)
  end

  def export_people
    @people = @extranet.connected_people
                       .ordered(current_language)
    filename = "people-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
    render "admin/university/people/index"
  end

  def export_organizations
    @organizations = @extranet.connected_organizations
                              .ordered(current_language)
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
    @object = PolymorphicObjectFinder.find(
      params,
      key: :object,
      university: current_university,
      permitted_classes: Communication::Extranet::Connection.permitted_about_classes
    )
  end
end
