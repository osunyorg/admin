class Admin::Education::ApplicationController < Admin::ApplicationController
  def breadcrumb
    super
    add_breadcrumb Education.model_name.human
  end
end
