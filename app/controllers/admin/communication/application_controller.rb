class Admin::Communication::ApplicationController < Admin::ApplicationController
  def breadcrumb
    super
    add_breadcrumb Communication.model_name.human
  end
end
