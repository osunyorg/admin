class Admin::Communication::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Communication.model_name.human
    @menu_collapsed = true if @website
  end
end
