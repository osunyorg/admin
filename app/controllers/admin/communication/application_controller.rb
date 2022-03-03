class Admin::Communication::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    if current_user.can_display_global_menu?
      if @website
        short_breadcrumb
        breadcrumb_for @website
      else
        super
        add_breadcrumb Communication.model_name.human
      end
    else
      super
      if @website
        add_breadcrumb Communication::Website.model_name.human(count: 2), admin_communication_websites_path
        breadcrumb_for @website
      end

    end
  end
end
