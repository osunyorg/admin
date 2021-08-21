class Admin::Communication::Website::ApplicationController < Admin::Communication::ApplicationController
  load_and_authorize_resource :website, class: Communication::Website

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website.model_name.human(count: 2), admin_communication_websites_path(journal_id: nil)
    breadcrumb_for @website, website_id: nil
  end

  def default_url_options
    return {} unless params.has_key? :website_id
    {
      website_id: params[:website_id]
    }
  end
end
