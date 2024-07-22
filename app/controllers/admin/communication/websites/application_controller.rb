class Admin::Communication::Websites::ApplicationController < Admin::Communication::ApplicationController
  load_and_authorize_resource :website,
                              class: Communication::Website,
                              through: :current_university,
                              through_association: :communication_websites

  protected

  def current_subnav_context
    @website && @website.persisted? ? 'navigation/admin/communication/website'
                                    : super
  end

  def breadcrumb
    super
    add_breadcrumb Communication::Website.model_name.human(count: 2), admin_communication_websites_path
    breadcrumb_for @website
  end

  def default_url_options
    options = super
    options[:website_id] = @website.id if @website&.persisted?
    options
  end
end
