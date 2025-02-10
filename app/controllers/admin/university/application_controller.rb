class Admin::University::ApplicationController < Admin::ApplicationController

  protected

  def current_subnav_context
    'navigation/admin/university'
  end

  def breadcrumb
    super
    add_breadcrumb t('university.description.title'), admin_university_root_path
  end

end
