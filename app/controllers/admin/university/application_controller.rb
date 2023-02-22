class Admin::University::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb University.model_name.human, admin_university_root_path
  end
end
