class Extranet::Library::DocumentsController < Extranet::Library::ApplicationController

  def index
    @facets = Communication::Extranet::Document::Facets.new params[:facets], current_extranet
    @documents = @facets.results
                        .published
                        .ordered
                        .page params[:page]
    breadcrumb
  end

end
