class Admin::Communication::Extranets::ApplicationController < Admin::Communication::ApplicationController
  load_and_authorize_resource :extranet,
                              class: Communication::Extranet,
                              through: :current_university,
                              through_association: :communication_extranets

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.model_name.human(count: 2), admin_communication_extranets_path
    breadcrumb_for @extranet
  end

  def default_url_options
    options = {}
    if @extranet.present?
      options[:extranet_id] = @extranet.id
    end
    options
  end
end
