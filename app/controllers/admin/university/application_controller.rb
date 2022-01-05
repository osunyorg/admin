class Admin::University::ApplicationController < Admin::ApplicationController
  def breadcrumb
    super
    add_breadcrumb University.model_name.human
  end
end
