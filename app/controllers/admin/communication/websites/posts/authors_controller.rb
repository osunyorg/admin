class Admin::Communication::Websites::Posts::AuthorsController < Admin::Communication::Websites::Posts::ApplicationController

  def index
    @authors =  @website.authors
                        .filter_by(params[:filters], current_language)
                        .accessible_by(current_ability)
                        .ordered(current_language)
                        .page(params[:page])
    @feature_nav = 'navigation/admin/communication/website/posts'
    breadcrumb
  end

  def show
    @author = @website.authors.accessible_by(current_ability).find(params[:id])
    @author_l10n = @author.localization_for(current_language)
    @posts = @author.communication_website_posts
                    .where(communication_website_id: @website.id)
                    .ordered(current_language)
                    .page(params[:page])
    breadcrumb
    add_breadcrumb @author_l10n
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('communication.authors', count: 2),
                   admin_communication_website_post_authors_path
  end

end
