class Admin::Communication::Website::HomeController < Admin::Communication::Website::ApplicationController
  before_action :get_home

  def edit
    breadcrumb
    add_breadcrumb Communication::Website::Home.model_name.human
  end

  def update
    if @home.update(home_params)
      redirect_to admin_communication_website_path(@website), notice: t('admin.successfully_updated_html', model: Communication::Website::Home.model_name.human)
    else
      breadcrumb
      add_breadcrumb Communication::Website::Home.model_name.human
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  def get_home
    @home = @website.home
  end

  def home_params
    params.require(:communication_website_home)
          .permit(
            :text, :featured_image, :featured_image_delete,
            :featured_image_infos, :featured_image_alt
          )
  end
end
