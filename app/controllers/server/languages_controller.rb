class Server::LanguagesController < Server::ApplicationController
  load_and_authorize_resource

  def index
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
    if @language.save
      redirect_to [:server, @language], notice: t('admin.successfully_created_html', model: @language.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @language.update(language_params)
      redirect_to [:server, @language], notice: t('admin.successfully_updated_html', model: @language.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @language.destroy
    redirect_to server_languages_url, notice: t('admin.successfully_destroyed_html', model: @language.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Language.model_name.human(count: 2), server_languages_path
    if @language
      if @language.persisted?
        add_breadcrumb @language, [:server, @language]
      else
        add_breadcrumb t('create')
      end
    end
  end

  def language_params
    params.require(:language).permit(:name, :iso_code)
  end
end
