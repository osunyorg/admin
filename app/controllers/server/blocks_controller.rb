class Server::BlocksController < Server::ApplicationController
  before_action :load_template, except: [:index]

  def index
    @templates = Communication::Block.template_kinds.keys
    breadcrumb
  end

  def show
    breadcrumb
    add_breadcrumb t("enums.communication.block.template_kind.#{@template}")
  end

  def resave
    @blocks.find_each &:save
    redirect_to server_block_path(@template), notice: "#{@blocks.count} blocks saved"
  end

  protected

  def load_template
    @template = params[:id]
    @blocks = Communication::Block.where(template_kind: @template)
  end

  def breadcrumb
    super
    add_breadcrumb Communication::Block.model_name.human(count: 2), server_blocks_path
  end
end
