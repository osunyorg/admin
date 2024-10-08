class Admin::Research::Laboratories::ApplicationController < Admin::Research::ApplicationController
  load_and_authorize_resource :laboratory,
                              class: Research::Laboratory,
                              through: :current_university,
                              through_association: :research_laboratories

  protected

  def current_subnav_context
    super
  end

  def breadcrumb
    super
    add_breadcrumb Research::Laboratory.model_name.human(count: 2), admin_research_laboratories_path
    add_breadcrumb @laboratory.to_s_in(current_language), [:admin, @laboratory]
  end

  def default_url_options
    options = super
    options[:laboratory_id] = params[:laboratory_id] if params.has_key? :laboratory_id
    options
  end
end
