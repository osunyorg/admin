class Admin::Communication::Extranets::ContactsController < Admin::Communication::Extranets::ApplicationController
  def index
    respond_to do |format|
      format.html {
        @people = current_university.people.ordered.page params[:persons_page]
        @organizations = current_university.organizations.ordered.page params[:organizations_page]
      }
      format.xlsx {
        # params[export] can be "people" oe "organizations"
        export = params['export']
        case params['export']
        when 'people'
          @people = @extranet.connected_people.ordered
        when 'organizations'
          @organizations = @extranet.connected_organizations.ordered
        else
          raise ActionController::RoutingError.new('Not Found')
        end

        filename = "#{export}-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
        render "admin/university/#{export}/index"
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

  def toggle
    load_object
    # connect / disconnect
    @connection = params[:connection]
    @connection == 'connect'  ? @extranet.connect(@object)
                              : @extranet.disconnect(@object)
    redirect_back(fallback_location: admin_communication_extranet_contacts_path(@extranet))
  end


  protected

  def load_object
    object_type = params[:objectType]
    object_id = params[:objectId]
    @object = object_type.constantize.find object_id
  end
end
