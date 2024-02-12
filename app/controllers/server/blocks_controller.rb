class Server::BlocksController < Server::ApplicationController
  
  before_action :load_template, except: [:index]

  def index
    @templates = Kaminari.paginate_array(Communication::Block.template_kinds.keys.sort_by { |k| t("enums.communication.block.template_kind.#{k}") }).page(params[:page])
    breadcrumb
  end

  def show
    @blocks = @blocks.page(params[:page])
    breadcrumb
    add_breadcrumb t("enums.communication.block.template_kind.#{@template}")
  end

  def resave
    @blocks.find_each(&:save)
    redirect_back fallback_location: server_block_path(@template), notice: t('server_admin.blocks.blocks_saved', count: @blocks.count)
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
