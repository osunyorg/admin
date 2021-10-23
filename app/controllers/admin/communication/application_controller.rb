class Admin::Communication::ApplicationController < Admin::ApplicationController
  def breadcrumb
    if @website
      short_breadcrumb
      breadcrumb_for @website
    else
      super
      add_breadcrumb Communication.model_name.human
    end
  end
end
