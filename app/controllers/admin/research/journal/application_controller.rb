class Admin::Research::Journal::ApplicationController < Admin::Research::ApplicationController
  load_and_authorize_resource :journal, class: Research::Journal

  protected

  def breadcrumb
    add_breadcrumb t('dashboard'), :admin_root_path
    add_breadcrumb '...'
    breadcrumb_for @journal, journal_id: nil
  end

  def default_url_options
    return {} unless params.has_key? :journal_id
    {
      journal_id: params[:journal_id]
    }
  end
end
