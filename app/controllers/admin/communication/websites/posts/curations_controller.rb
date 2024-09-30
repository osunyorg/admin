class Admin::Communication::Websites::Posts::CurationsController < Admin::Communication::Websites::Posts::ApplicationController
  def new
    breadcrumb
  end

  def create
    @curator = Importers::Curator.new @website, current_user, current_language, curation_params[:url]
    if @curator.valid?
      @post =  @curator.post
      redirect_to [:admin, @post],
                  notice: t('admin.successfully_created_html', model: @post.to_s_in(current_language))
    else
      breadcrumb
      @url = curation_params[:url]
      flash[:alert] = @curator.already_imported? ? t('curation.already_imported') : t('curation.error')
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  t('communication.website.posts.new_curation')
  end

  def curation_params
    params.require(:curation).permit(:url)
  end
end
