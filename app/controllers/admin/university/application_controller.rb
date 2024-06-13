class Admin::University::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb University.model_name.human, admin_university_root_path if current_university.is_really_a_university
  end

  def default_url_options
    options = {}
    options[:lang] = current_language.iso_code
    options
  end

  def current_language
    @current_language ||= current_university.best_language_for(params[:lang])
  end
  helper_method :current_language

end
