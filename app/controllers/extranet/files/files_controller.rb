class Extranet::Files::FilesController < Extranet::Files::ApplicationController

  def index
    @files = current_extranet.files
                             .published
                             .ordered
                             .page(params[:page])
    breadcrumb
  end

  def show
    @file = current_extranet.files.find params[:id]
    breadcrumb
    add_breadcrumb @file
  end
end
