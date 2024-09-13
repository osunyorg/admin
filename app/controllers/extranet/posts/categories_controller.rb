class Extranet::Posts::CategoriesController < Extranet::Posts::ApplicationController

  def index
    @categories = current_extranet.post_categories
                                  .ordered(current_language)
    breadcrumb
    add_breadcrumb Communication::Extranet::Post::Category.model_name.human(count: 2)
  end

  def show
    @l10n = current_extranet.post_category_localizations
                            .find_by(slug: params[:slug])
    @category = @l10n.about
    @posts = @category.posts
                      .published(current_language)
                      .ordered(current_language)
                      .page(params[:page])
    breadcrumb
    add_breadcrumb @l10n
  end
end
