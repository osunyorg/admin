class Extranet::Posts::PostsController < Extranet::Posts::ApplicationController
  def index
    @posts =  current_extranet.posts
                              .published(current_language)
                              .ordered(current_language)
                              .page(params[:page])
    breadcrumb
  end

  def show
    @l10n = current_extranet.post_localizations
                            .published
                            .find_by!(slug: params[:slug])
    @post = @l10n.about
    @disable_container = true
    breadcrumb
    add_breadcrumb @l10n
  end
end
