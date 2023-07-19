class Admin::University::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb University.model_name.human, admin_university_root_path if current_university.is_really_a_university
  end
end
