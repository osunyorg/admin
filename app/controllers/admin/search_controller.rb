class Admin::SearchController < Admin::ApplicationController
  def index
    @term = params[:term]
    @results =  current_university.search
                                  .for(@term)
                                  .in(current_language)
  end
end