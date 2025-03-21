module Admin::ActAsCategories
  extend ActiveSupport::Concern

  included do
    before_action :ensure_category_is_editable, only: [:edit, :update, :destroy]
  end

  def reorder
    parent_id = params.dig(:parentId)
    old_parent_id = params.dig(:oldParentId)
    ids = params[:ids] || []
    ids.each.with_index do |id, index|
      category = categories.find(id)
      category.update_columns parent_id: parent_id,
                              position: index + 1
    end
    if old_parent_id.present?
      old_parent = categories.find(old_parent_id)
      trigger_category_sync(old_parent)
    end
    category = categories.find(params[:itemId])
    trigger_category_sync(category) # Will sync siblings
  end

  def children
    if request.xhr?
      @categories_class = categories_class
      @category = categories.find(params[:id])
      @children =  @category.children
                            .ordered(current_language)
      render 'admin/application/categories/children'
    else
      redirect_to [:admin, categories_class]
    end
  end

  protected

  # Good for websites, but needs override for other objects
  def categories
    categories_class.where(communication_website_id: @website.id)
                    .ordered(current_language)
  end

  # Communication::Website::Agenda::Category
  def categories_class
    raise NoMethodError.new("categories_class must be implemented in the controller, for example Communication::Website::Agenda::Category")
  end

  def permitted_params_for(object_key)
    params.require(object_key).permit(
      :is_taxonomy, :parent_id, :bodyclass,
      localizations_attributes: [
        :id, :name, :slug, :summary, :meta_description, :language_id,
        :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit
      ]).merge(university_id: current_university.id)
  end

  def trigger_category_sync(category)
    if category.respond_to?(:sync_with_git)
      category.sync_with_git
    else
      # Indirect object (Person category, ...)
      category.touch
    end
  end

  def ensure_category_is_editable
    render_forbidden unless @category.editable?
  end
end