class Admin::Communication::Websites::Posts::AuthorsController < Admin::Communication::Websites::Posts::ApplicationController

  has_scope :for_search_term

  def index
    @authors =  apply_scopes(@website.authors.accessible_by(current_ability))
                                .ordered
                                .page(params[:page])
    @feature_nav = 'navigation/admin/communication/website/posts'
    breadcrumb
  end

  def show
    @author = @website.authors.accessible_by(current_ability).find(params[:id])
    @posts = @author.communication_website_posts.where(communication_website_id: @website.id).ordered.page(params[:page])
    breadcrumb
    add_breadcrumb @author
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('communication.authors', count: 2),
                   admin_communication_website_post_authors_path
  end

end
