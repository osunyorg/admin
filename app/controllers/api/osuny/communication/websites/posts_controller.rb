class Api::Osuny::Communication::Websites::PostsController < Api::Osuny::Communication::Websites::ApplicationController
  def index
    @posts = website.posts.published
  end

  def show
    @post = website.posts.find params[:id]
  end

  # TODO create
  def import
    Importers::Api::Osuny::Communication::Website::Post.new university: current_university,
                                                            website: website,
                                                            params: params[:post]
    render json: :ok
  end
end
