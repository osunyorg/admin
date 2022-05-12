class Server::BlocksController < Server::ApplicationController
  def index
    @templates = Communication::Block.template_kinds.keys
    breadcrumb
  end

  def show
    @template = params[:id]
    @blocks = Communication::Block.send(@template)
    breadcrumb
    add_breadcrumb t("enums.communication.block.template_kind.#{@template}")
  end

  def resave
    @template = params[:id]
    @blocks = Communication::Block.send(@template)
    @blocks.find_each &:save
    redirect_to server_block_path(@template), notice: "#{@blocks.count} blocks saved"
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Block.model_name.human(count: 2), server_blocks_path
  end
end
