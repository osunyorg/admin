class Api::Osuny::Communication::Websites::PostsController < Api::Osuny::Communication::Websites::ApplicationController
  before_action :load_post, only: [:create, :update]

  def index
    @posts = website.posts.includes(:localizations)
  end

  def show
    @post = website.posts.find params[:id]
  end

  def create
    @post.assign_attributes post_params
    if @post.save
      render json: @post
    else
      render json: @post.errors
    end
  end

  def update
    if @post.update post_params
      render json: @post
    else
      render json: @post.errors
    end
  end

  # def import
  #   Importers::Api::Osuny::Communication::Website::Post.new university: current_university,
  #                                                           website: website,
  #                                                           params: params[:post]
  #   render json: :ok
  # end

  protected

  def load_post
    @migration_identifier = params.dig(:post, :migration_identifier)
    @language = Language.find_by(iso_code: params.dig(:post, :locale))
    @post = website.posts.where(
        migration_identifier: @migration_identifier,
        language: @language
      ).first_or_initialize
  end

  def post_params
    params.require(:post)
          .permit(
            :title, :summary, :published
          ).merge(
            university_id: current_university.id,
            communication_website_id: website.id
          )
  end
end
