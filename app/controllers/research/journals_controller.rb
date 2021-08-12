class Research::JournalsController < ApplicationController
  def index
    @journals = current_university.research_journals
  end

  def show
    @journal = current_university.research_journals.find params[:id]
  end
end
