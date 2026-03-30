module Admin::HasMoveAction
  extend ActiveSupport::Concern

  included do
    before_action :load_object, :load_target_websites, :ensure_access, only: [:move, :do_move]
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

  protected

  def load_object
    # resource is inherited from localizable concern, only working because "movable" object are also localizable. 
    # If we want to use this concern for non-localizable objects, we would need to define a method to load the object instead of relying on resource.
    @object = resource
  end

  def load_target_websites
    @target_websites = current_user.managed_websites
                                   .where(university_id: @object.university_id)
                                   .where.not(id: @object.communication_website_id)
  end
  
  def ensure_access
    unless can?(:move, @object) && @target_websites.count > 0
      redirect_to [:admin, @object], alert: t('admin.move.permission_denied')
    end
  end

end