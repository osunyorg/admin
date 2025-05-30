class Server::BlocksController < Server::ApplicationController
  
  def index
    @blocks = Communication::Block.filter_by(params[:filters], current_language)
                                  .ordered
                                  .page(params[:page])
    breadcrumb
  end

  def show
    @block = Communication::Block.find(params[:id])
    breadcrumb
    add_breadcrumb @block
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Block.model_name.human(count: 2), server_blocks_path
  end
  
end
