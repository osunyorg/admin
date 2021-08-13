class Admin::Research::Journal::ApplicationController < Admin::Research::ApplicationController
  load_and_authorize_resource :journal, class: Research::Journal

  protected

  def breadcrumb
    super
    add_breadcrumb Research::Journal.model_name.human(count: 2), admin_research_journals_path
    breadcrumb_for @journal
  end

  def default_url_options
    {
      journal_id: params[:journal_id]
    }
  end
end
