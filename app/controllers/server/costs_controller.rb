class Server::CostsController < Server::ApplicationController
  load_and_authorize_resource class: Server::Cost

  def index
    @costs = @costs.ordered
    breadcrumb
  end

  def show
    breadcrumb
    add_breadcrumb @cost
  end

  def new
    breadcrumb
    add_breadcrumb t('create')
  end

  def edit
    breadcrumb
    add_breadcrumb @cost, server_cost_path(@cost)
    add_breadcrumb t('edit')
  end

  def create
    if @cost.save
      redirect_to server_cost_path(@cost), notice: t('admin.successfully_created_html', model: @cost.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @cost.update(cost_params)
      redirect_to server_cost_path(@cost), notice: t('admin.successfully_updated_html', model: @cost.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @cost.destroy
    redirect_to server_costs_url, notice: t('admin.successfully_destroyed_html', model: @cost.to_s)
  end


  protected

  def breadcrumb
    super
    add_breadcrumb Server::Cost.model_name.human(count: 2), server_costs_path
  end

  def cost_params
    params.require(:server_cost)
          .permit(:name, :description, :annual_amount)
  end
end
