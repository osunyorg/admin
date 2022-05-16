class Admin::Research::Journals::ApplicationController < Admin::Research::ApplicationController
  load_and_authorize_resource :journal,
                              class: Research::Journal,
                              through: :current_university,
                              through_association: :research_journals

  protected

  def default_url_options
    return {} unless params.has_key? :journal_id
    {
      journal_id: params[:journal_id]
    }
  end
end
