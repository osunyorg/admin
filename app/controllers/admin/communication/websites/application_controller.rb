class Admin::Communication::Websites::ApplicationController < Admin::Communication::ApplicationController
  load_and_authorize_resource :website,
                              class: Communication::Website,
                              through: :current_university,
                              through_association: :communication_websites

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website.model_name.human(count: 2), admin_communication_websites_path
    breadcrumb_for @website
  end

  def default_url_options
    return {} unless params.has_key? :website_id
    {
      website_id: params[:website_id]
    }
  end
end
