class Admin::Communication::Website::AuthorsController < Admin::Communication::Website::ApplicationController

  has_scope :for_search_term
  
  def index
    @authors =  apply_scopes(@website.authors.accessible_by(current_ability))
                                .ordered
                                .page(params[:page])
    breadcrumb
  end

  def show
    @author = @website.authors.accessible_by(current_ability).find(params[:id])
    @posts = @author.communication_website_posts.where(communication_website_id: @website.id).ordered.page(params[:page])
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb t('communication.authors', count: 2),
                   admin_communication_website_authors_path
    breadcrumb_for @author
  end

end
