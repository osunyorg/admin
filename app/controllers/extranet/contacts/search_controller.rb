class Extranet::Contacts::SearchController < Extranet::Contacts::ApplicationController
  def index
    @term = params[:term]
    @people = current_extranet.connected_people
                              .tmp_original
                              .for_search_term(@term)
                              .ordered(current_language)
                              .limit(20)
    @organizations =  current_extranet.connected_organizations
                                      .tmp_original
                                      .for_search_term(@term)
                                      .ordered(current_language)
                                      .limit(20)
    breadcrumb
    add_breadcrumb 'Recherche'
  end
end
