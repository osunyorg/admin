class Research::Journal::VolumesController < ApplicationController
  def index
    @journal = current_university.research_journals.find params[:journal_id]
    @volumes = @journal.volumes
    breadcrumb
  end

  def show
    @journal = current_university.research_journals.find params[:journal_id]
    @volume = @journal.volumes.find params[:id]
    @articles = @volume.articles
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research.model_name.human
    add_breadcrumb Research::Journal.model_name.human(count: 2), research_journals_path
    add_breadcrumb @journal, @journal
    add_breadcrumb @volume if @volume
  end
end
