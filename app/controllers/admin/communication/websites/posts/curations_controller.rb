class Admin::Communication::Websites::Posts::CurationsController < Admin::Communication::Websites::ApplicationController
  def new
    breadcrumb
  end

  def create
    @curator = Curator.new @website, current_user, current_website_language, curation_params[:url]
    if @curator.valid?
      redirect_to [:admin, @curator.post],
                  notice: t('admin.successfully_created_html', model: @curator.post.to_s)
    else
      breadcrumb
      @url = curation_params[:url]
      flash[:alert] = t('curation.error')
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Post.model_name.human(count: 2),
                    admin_communication_website_posts_path
    add_breadcrumb  t('communication.website.posts.new_curation')
  end

  def curation_params
    params.require(:curation).permit(:url)
  end
end
