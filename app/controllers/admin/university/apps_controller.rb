class Admin::University::AppsController < Admin::University::ApplicationController
  load_and_authorize_resource class: University::App,
                              through: :current_university,
                              through_association: :apps

  def index
    @apps = apply_scopes(@apps).ordered.page(params[:page])
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
    if @app.save
      redirect_to admin_university_app_path(@app),
                  notice: t('admin.successfully_created_html', model: @app.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @app.update(app_params)
      redirect_to admin_university_app_path(@app),
                  notice: t('admin.successfully_updated_html', model: @app.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
    end
  end

  def destroy
    @app.destroy
    redirect_to admin_university_apps_url,
                notice: t('admin.successfully_destroyed_html', model: @app.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  University::App.model_name.human(count: 2),
                    admin_university_apps_path
    breadcrumb_for @app
  end

  def app_params
    params.require(:university_app)
          .permit(:name)
          .merge(university_id: current_university.id)
  end
end