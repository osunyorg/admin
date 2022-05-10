class Admin::Research::Laboratories::ApplicationController < Admin::Research::ApplicationController
  load_and_authorize_resource :laboratory,
                              class: Research::Laboratory,
                              through: :current_university,
                              through_association: :research_laboratories

  protected

  def default_url_options
    return {} unless params.has_key? :laboratory_id
    {
      laboratory_id: params[:laboratory_id]
    }
  end
end
