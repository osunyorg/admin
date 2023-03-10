class Extranet::Posts::CategoriesController < Extranet::Posts::ApplicationController

  def index
    @categories = current_extranet.post_categories.ordered
    breadcrumb
    add_breadcrumb Communication::Extranet::Post::Category.model_name.human(count: 2)
  end

  def show
    @category = current_extranet.post_categories.find_by slug: params[:slug]
    @posts = @category.posts.ordered.page params[:page]
    breadcrumb
    add_breadcrumb @category
  end
end
