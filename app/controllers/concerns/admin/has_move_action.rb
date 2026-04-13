module Admin::HasMoveAction
  extend ActiveSupport::Concern

  included do
    before_action :load_target_websites, only: [:move, :do_move, :move_batch, :do_move_batch]
    before_action :load_object, :ensure_access, only: [:move, :do_move]
  end

  def move
    breadcrumb
    add_breadcrumb t('admin.move.cta')
    render 'admin/application/move/move'
  end

  def do_move
    new_website = @target_websites.find(params[:new_website_id])
    redirect_to [:admin, @object], alert: t('admin.move.permission_denied') and return unless new_website
    redirect_to [:admin, @object], alert: t('admin.move.permission_denied') and return if new_website.university_id != @object.university_id
    @object.move_to!(new_website)
    redirect_to [:admin, @object, website_id: new_website.id], notice: t('admin.move.successfully_moved', model: @object.to_s_in(current_language))
  end

  def move_batch
    @filtered = @website.public_send(resources)
                        .filter_by(params[:filters], current_language)
    @objects = @filtered.at_lifecycle(params[:lifecycle], current_language)
                        .ordered(current_language)
                        .page(params[:page])
    @resource_name = resources
    breadcrumb
    add_breadcrumb t('admin.move.cta')
    render 'admin/application/move/move_batch'
  end

  def do_move_batch
    target_website = @target_websites.find(params[:target])
    ids = params[:ids].compact_blank || []
    ids.each do |id|
      object = @website.public_send(resources).find_by(id: id)
      object.move_to!(target_website)
    end
    redirect_to public_send("admin_communication_website_#{resources}_path", website_id: @website.id),
                notice: t('batch.movable.successfully_moved')
  end

  protected

  def load_object
    # resource is inherited from localizable concern, only working because "movable" object are also localizable. 
    # If we want to use this concern for non-localizable objects, we would need to define a method to load the object instead of relying on resource.
    @object = resource
  end

  def load_target_websites
    @target_websites = current_user.managed_websites
                                   .where(university_id: @website.university_id)
                                   .where.not(id: @website.id)
  end
  
  def ensure_access
    unless can?(:move, @object) && @target_websites.count > 0
      redirect_to [:admin, @object], alert: t('admin.move.permission_denied')
    end
  end

  def resources
    self.class.to_s.remove("Controller").demodulize.underscore
  end

end