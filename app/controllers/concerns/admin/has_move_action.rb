module Admin::HasMoveAction
  extend ActiveSupport::Concern

  included do
    before_action :load_target_websites, only: [:move, :do_move, :move_batch, :do_move_batch]
    before_action :load_and_authorize_target_website, only: [:do_move, :do_move_batch]
    before_action :load_object, :ensure_access, only: [:move, :do_move]
  end

  def move
    breadcrumb
    add_breadcrumb t('admin.move.cta')
    render 'admin/application/move/move'
  end

  def do_move
    raise CanCan::AccessDenied unless can?(:move, @object)
    @object.move_to!(@target_website)
    redirect_to [:admin, @object, website_id: @target_website.id],
                notice: t('admin.move.successfully_moved', model: @object.to_s_in(current_language))
  end

  def move_batch
    @filtered = @website.public_send(resource_plural_name)
                        .filter_by(params[:filters], current_language)
    @objects = @filtered.at_lifecycle(params[:lifecycle], current_language)
                        .ordered(current_language)
                        .page(params[:page])
    @resource_plural_name = resource_plural_name
    breadcrumb
    add_breadcrumb t('admin.move.cta')
    render 'admin/application/move/move_batch'
  end

  def do_move_batch
    ids = params[:ids]&.compact_blank || []
    ids.each do |id|
      object = @website.public_send(resource_plural_name).find_by(id: id)
      object.move_to!(@target_website) if can?(:move, object)
    end
    redirect_to public_send("admin_communication_website_#{resource_plural_name}_path", website_id: @target_website.id),
                notice: t('batch.movable.successfully_moved')
  end

  protected

  def load_object
    # resource is inherited from localizable concern, only working because "movable" object are also localizable.
    # If we want to use this concern for non-localizable objects, we would need to define a method to load the object
    # instead of relying on resource.
    @object = resource
  end

  def load_target_websites
    @target_websites = current_user.managed_websites
                                   .where(university_id: @website.university_id)
                                   .where.not(id: @website.id)
    redirect_back(fallback_location: [:admin, @website], alert: t('admin.move.permission_denied')) if @target_websites.empty?
  end

  def load_and_authorize_target_website
    @target_website = @target_websites.find_by(id: params[:new_website_id])
    if @target_website.nil? || @target_website.university_id != @website.university_id
      redirect_back(fallback_location: [:admin, @website], alert: t('admin.move.permission_denied'))
    end
  end

  def ensure_access
    redirect_back(fallback_location: [:admin, @website], alert: t('admin.move.permission_denied')) unless can?(:move, @object)
  end

  def resource_plural_name
    # Admin::Communication::Websites::PostsController => "posts"
    # Admin::Communication::Websites::Agenda::EventsController => "agenda_events"
    self.class.to_s
      .delete_suffix("Controller")
      .delete_prefix("Admin::Communication::Websites::")
      .gsub('::', '')
      .underscore
  end

end
