class Extranet::Library::DocumentsController < Extranet::Library::ApplicationController

  def index
    @documents =  current_extranet.documents
                                  .published
                                  .ordered
                                  .page(params[:page])
    breadcrumb
  end

end
