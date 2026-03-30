module Admin::HasMoveAction
  extend ActiveSupport::Concern

  included do
    before_action :ensure_access, :load_object, only: [:move, :do_move]
  end

  def move
    breadcrumb
    add_breadcrumb t('admin.move.cta')
    render 'admin/application/move/move'
  end

  def do_move
    new_website = current_user.managed_websites.find(params[:new_website_id])
    redirect_to [:admin, @object], alert: t('admin.move.permission_denied') and return unless new_website
    old_university = @object.university
    new_university = new_website.university
    @object.move_to!(new_website)
    if old_university != new_university
      redirect_to admin_communication_website_posts_path(new_website), notice: t('admin.move.successfully_moved', model: @object.to_s_in(current_language))
    else
      redirect_to [:admin, @object, website_id: new_website.id], notice: t('admin.move.successfully_moved', model: @object.to_s_in(current_language))
    end
  end

  protected
  
  def ensure_access
    unless can?(:move, @object) && current_user.managed_websites.count > 1
      redirect_to [:admin, @object], alert: t('admin.move.permission_denied')
    end
  end

  def load_object
    # resource is inherited from localizable concern, only working because "movable" object are also localizable. 
    # If we want to use this concern for non-localizable objects, we would need to define a method to load the object instead of relying on resource.
    @object = resource
  end

end