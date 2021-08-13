class Research::JournalsController < ApplicationController
  def index
    @journals = current_university.research_journals
    breadcrumb
  end

  def show
    @journal = current_university.research_journals.find params[:id]
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research.model_name.human
    add_breadcrumb Research::Journal.model_name.human(count: 2), research_journals_path
    add_breadcrumb @journal, @journal if @journal
  end
end
