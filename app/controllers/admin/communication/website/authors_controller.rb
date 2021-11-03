class Admin::Communication::Website::AuthorsController < Admin::Communication::Website::ApplicationController
  load_and_authorize_resource class: Communication::Website::Author

  def index
    @authors = @website.authors.ordered.page(params[:page])
    breadcrumb
  end

  def show
    @posts = @author.posts.ordered.page(params[:page])
    breadcrumb
  end

  def new
    @author.website = @website
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @author.website = @website
    if @author.save
      redirect_to admin_communication_website_author_path(@author), notice: t('admin.successfully_created_html', model: @author.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      redirect_to admin_communication_website_author_path(@author), notice: t('admin.successfully_updated_html', model: @author.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy
    redirect_to admin_communication_website_authors_url, notice: t('admin.successfully_destroyed_html', model: @author.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Author.model_name.human(count: 2),
                    admin_communication_website_authors_path
    breadcrumb_for @author
  end

  def author_params
    params.require(:communication_website_author)
          .permit(:website_id, :first_name, :last_name, :biography, :slug, :user_id)
          .merge(university_id: current_university.id)
  end
end
