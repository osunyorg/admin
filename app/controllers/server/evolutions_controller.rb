class Server::EvolutionsController < Server::ApplicationController
  
  load_and_authorize_resource

  def index
    @evolutions = @evolutions.ordered.page(params[:page])
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @evolution.save
      redirect_to @evolution,
                  notice: t('admin.successfully_created_html', model: @evolution.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @evolution.update(evolution_params)
      redirect_to @evolution,
                  notice: t('admin.successfully_updated_html', model: @evolution.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @evolution.destroy
    redirect_to server_evolutions_url,
                notice: t('admin.successfully_destroyed_html', model: @evolution.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Server::Evolution.model_name.human(count: 2), server_evolutions_path
    if @evolution
      if @evolution.persisted?
        add_breadcrumb @l10n, @evolution
      else
        add_breadcrumb t('create')
      end
    end
  end

  def evolution_params
    params.require(:server_evolution).permit(
      :released_at,
      localizations_attributes: [
        :id, :language_id, :title, :text
      ]
    )
  end
end
