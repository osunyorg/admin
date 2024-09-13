class Extranet::Documents::DocumentsController < Extranet::Documents::ApplicationController

  def index
    @facets = Communication::Extranet::Document::Facets.new params[:facets], 
                                                            current_extranet, 
                                                            current_language
    @documents = @facets.results
                        .ordered(current_language)
                        .page(params[:page])
    breadcrumb
  end

end
