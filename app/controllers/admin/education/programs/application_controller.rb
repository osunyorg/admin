class Admin::Education::Programs::ApplicationController < Admin::Education::ApplicationController
  load_and_authorize_resource :program,
                              class: Education::Program,
                              through: :current_university,
                              through_association: :education_programs

  protected

  def breadcrumb
    super
    add_breadcrumb @program, [:admin, @program]
  end

  def default_url_options
    return {} unless params.has_key? :program_id
    {
      program_id: params[:program_id]
    }
  end
end
