class Api::Osuny::Communication::Websites::Agenda::EventsController < Api::Osuny::Communication::Websites::ApplicationController
  before_action :build_event, only: :create
  before_action :load_event, only: [:show, :update, :destroy]

  before_action :load_migration_identifier, only: [:create, :update]
  before_action :ensure_same_migration_identifier, only: :update

  def index
    @events = website.events.includes(:localizations)
  end

  def show
  end

  def create
    if @event.save
      render :show, status: :created
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render :show
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  # def upsert
  #   posts_params = params[:posts] || []
  #   every_post_has_migration_identifier = posts_params.all? { |post_params|
  #     post_params[:migration_identifier].present?
  #   }
  #   unless every_post_has_migration_identifier
  #     render_on_missing_migration_identifier
  #     return
  #   end

  #   permitted_posts_params = posts_params.map { |unpermitted_params|
  #     post_params_for_upsert(unpermitted_params)
  #   }
  #   @successfully_created_posts = []
  #   @successfully_updated_posts = []
  #   @invalid_posts_with_index = []
  #   permitted_posts_params.each_with_index do |permitted_post_params, index|
  #     post = website.posts.find_by(migration_identifier: permitted_post_params[:migration_identifier])
  #     if post.present?
  #       if post.update(permitted_post_params)
  #         @successfully_updated_posts << post
  #       else
  #         @invalid_posts_with_index << { post: post, index: index }
  #       end
  #     else
  #       post = website.posts.build(permitted_post_params)
  #       if post.save
  #         @successfully_created_posts << post
  #       else
  #         @invalid_posts_with_index << { post: post, index: index }
  #       end
  #     end
  #   end

  #   status = @invalid_posts_with_index.any? ? :unprocessable_entity : :ok
  #   render 'upsert', status: status
  # end

  def destroy
    @event.destroy
    head :no_content
  end

  protected

  def build_event
    @event = website.events.build
    @event.assign_attributes(event_params)
  end

  def load_event
    @event = website.events.find(params[:id])
  end

  def load_migration_identifier
    @migration_identifier = event_params[:migration_identifier]
    render_on_missing_migration_identifier unless @migration_identifier.present?
  end

  def ensure_same_migration_identifier
    if @event.migration_identifier != @migration_identifier
      render json: { error: 'Migration identifier does not match' }, status: :unprocessable_entity
    end
  end

  def l10n_permitted_keys
    [
      :migration_identifier, :language, :title, :meta_description,
      :published, :published_at, :slug, :subtitle, :summary, :text, :_destroy,
      featured_image: [:url, :alt, :credit, :_destroy],
      blocks: [:migration_identifier, :template_kind, :title, :position, :published, :html_class, data: {}]
    ]
  end

  def event_params
    @event_params ||= begin
      permitted_params = params.require(:event)
                          .permit(
                            :migration_identifier, :from_day, :from_hour, :to_day, :to_hour, :time_zone,
                            :created_by_id, :parent_id, localizations: {}
                          ).merge(
                            university_id: current_university.id,
                            communication_website_id: website.id
                          )
      set_l10n_attributes(permitted_params, @event) if permitted_params[:localizations].present?
      permitted_params
    end
  end

  # def post_params_for_upsert(post_params)
  #   permitted_params = post_params
  #                         .permit(
  #                           :migration_identifier, :full_width, localizations: {}
  #                         ).merge(
  #                           university_id: current_university.id,
  #                           communication_website_id: website.id
  #                         )
  #   post = website.posts.find_by(migration_identifier: permitted_params[:migration_identifier])
  #   permitted_params[:id] = post.id if post.present?
  #   set_l10n_attributes(permitted_params, post) if permitted_params[:localizations].present?
  #   permitted_params
  # end
end
