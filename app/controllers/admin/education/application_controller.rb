class Admin::Education::ApplicationController < Admin::ApplicationController
  def breadcrumb
    if @program
      short_breadcrumb
    else
      super
      add_breadcrumb Education.model_name.human
    end

  end
end
