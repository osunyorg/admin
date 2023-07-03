class Extranet::Posts::PostsController < Extranet::Posts::ApplicationController

  def index
    @posts = current_extranet.posts
                             .published
                             .ordered
                             .page(params[:page])
    breadcrumb
  end

  def show
    @post = current_extranet.posts.find_by! slug: params[:slug]
    @disable_container = true
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb @post if @post
  end
end
