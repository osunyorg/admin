class Admin::Research::Journals::ApplicationController < Admin::Research::ApplicationController
  load_and_authorize_resource :journal,
                              class: Research::Journal,
                              through: :current_university,
                              through_association: :research_journals

  protected

  def current_subnav_context
    @journal && @journal.persisted? ? 'navigation/admin/research/journal' 
                                    : super
  end

  def breadcrumb
    super
    add_breadcrumb Research::Journal.model_name.human(count: 2), admin_research_journals_path
    breadcrumb_for @journal
  end

  def default_url_options
    options = super
    options[:journal_id] = params[:journal_id] if params.has_key? :journal_id
    options
  end
end
