class Research::Journal::VolumesController < ApplicationController
  def index
    @journal = current_university.research_journals.find params[:journal_id]
    @volumes = @journal.volumes
    breadcrumb
  end

  def show
    @journal = current_university.research_journals.find params[:journal_id]
    @volume = @journal.volumes.find params[:id]
    breadcrumb
    add_breadcrumb @volume
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research.model_name.human
    add_breadcrumb Research::Journal.model_name.human(count: 2), research_journals_path
    add_breadcrumb @journal, @journal
    add_breadcrumb Research::Journal::Volume.model_name.human(count: 2), research_journal_volumes_path(journal_id: @journal)
  end
end
