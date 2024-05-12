class Server::TagsController < Server::ApplicationController
  load_and_authorize_resource class: Communication::Website::Showcase::Tag

  def index
    breadcrumb
  end

  def show
    breadcrumb
    add_breadcrumb @tag
  end

  def new
    breadcrumb
    add_breadcrumb t('create')
  end

  def edit
    breadcrumb
    add_breadcrumb @tag, server_tag_path(@tag)
    add_breadcrumb t('edit')
  end

  def create
    if @tag.save
      redirect_to server_tag_path(@tag), notice: t('admin.successfully_created_html', model: @tag.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @tag.update(tag_params)
      redirect_to server_tag_path(@tag), notice: t('admin.successfully_updated_html', model: @tag.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    redirect_to server_tags_url, notice: t('admin.successfully_destroyed_html', model: @tag.to_s)
  end


  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website::Showcase::Tag.model_name.human(count: 2), server_tags_path
  end

  def tag_params
    params.require(:communication_website_showcase_tag)
          .permit(:name, website_ids: [])
  end
end