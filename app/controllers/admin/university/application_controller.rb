class Admin::University::ApplicationController < Admin::ApplicationController

  protected

  def current_subnav_context
    'navigation/admin/university'
  end

  def breadcrumb
    super
    add_breadcrumb University.model_name.human, admin_university_root_path if current_university.is_really_a_university
  end
end
