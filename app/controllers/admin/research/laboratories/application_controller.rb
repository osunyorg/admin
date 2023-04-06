class Admin::Research::Laboratories::ApplicationController < Admin::Research::ApplicationController
  load_and_authorize_resource :laboratory,
                              class: Research::Laboratory,
                              through: :current_university,
                              through_association: :research_laboratories

  protected

  def breadcrumb
    super
    add_breadcrumb Research::Laboratory.model_name.human(count: 2), admin_research_laboratories_path
    add_breadcrumb @laboratory, [:admin, @laboratory]
  end

  def default_url_options
    return {} unless params.has_key? :laboratory_id
    {
      laboratory_id: params[:laboratory_id]
    }
  end
end
