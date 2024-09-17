class Admin::SearchController < Admin::ApplicationController
  def index
    @term = params[:term]
    if @term.present?
      @results =  current_university.search
                                    .for(@term)
                                    .in(current_language)
                                    .limit(30)
    else
      @results = Search.none
    end
    render layout: false
  end
end