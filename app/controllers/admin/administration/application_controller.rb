class Admin::Administration::ApplicationController < Admin::ApplicationController
  def breadcrumb
    super
    add_breadcrumb Administration.model_name.human
  end
end
