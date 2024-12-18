class Admin::Education::Programs::ApplicationController < Admin::Education::ApplicationController
  load_and_authorize_resource :program,
                              class: Education::Program,
                              through: :current_university,
                              through_association: :education_programs

  protected

  def current_subnav_context
    @program && @program.persisted? ? 'navigation/admin/education/program'
                                    : super
  end

  def breadcrumb
    super
    add_breadcrumb Education::Program.model_name.human(count: 2), admin_education_programs_path
    @program.ancestors_and_self.each do |program|
      add_breadcrumb program.to_s_in(current_language), admin_education_program_path(program)
    end
  end

  def default_url_options
    options = super
    options[:program_id] = params[:program_id] if params.has_key? :program_id
    options
  end
end
