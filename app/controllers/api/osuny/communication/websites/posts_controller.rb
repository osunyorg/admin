class Api::Osuny::Communication::Websites::PostsController < Api::Osuny::ApplicationController
  skip_before_action :verify_authenticity_token, only: :import
  before_action :verify_app_token, only: :import

  def import
    create_post
    import_blocks
    render json: :ok
  end

  protected

  def create_post
    post.language = website.default_language
    post.update post_params
    post.save
  end

  def post
    @post ||= website.posts
                  .where(
                    university: current_university,
                    website: website,
                    migration_identifier: migration_identifier
                  )
                  .first_or_initialize
  end

  def import_blocks
    blocks.each do |b|
      migration_identifier = b[:migration_identifier]
      template_kind = b[:template_kind]
      block = post.blocks
                  .where(
                    template_kind: template_kind,
                    migration_identifier: migration_identifier
                  )
                  .first_or_initialize
      block.university = current_university
      data = b[:data].to_unsafe_hash
      block.data = block.template.data.merge data
      block.save
    end
  end

  def blocks
    return [] unless params[:post].has_key?(:blocks)
    @blocks ||= params[:post][:blocks]
  end

  def website
    @website ||= current_university.websites.find params[:website_id]
  end

  def migration_identifier
    @migration_identifier ||= params[:migration_identifier]
  end

  def post_params
    params.require(:post)
          .permit(
            :title, :language, :meta_description, :summary,
          )
  end

end
