module Admin::ActAsCategories
  extend ActiveSupport::Concern

  included do
    before_action :ensure_category_is_editable, only: [:edit, :update, :destroy]
    before_action :ensure_xhr, only: [:reorder, :children]
  end

  def reorder
    moved_category_id = params.dig(:itemId)
    moved_category = categories.find(moved_category_id)
    parent_id = params.dig(:parentId)

    if moved_category.is_taxonomy? && parent_id.present?
      render plain: I18n.t('admin.categories.cant_move_taxonomy_here'), status: :unprocessable_entity
    else
      old_parent_id = params.dig(:oldParentId)
      ids = params[:ids] || []
      ids.each.with_index do |id, index|
        category = categories.find(id)
        category.update_columns parent_id: parent_id,
                                position: index + 1
      end
      if old_parent_id.present?
        old_parent = categories.find(old_parent_id)
        old_parent.touch
      end
      category = categories.find(params[:itemId])
      category.touch
      head :ok
    end
  end

  def children
    @categories_class = categories_class
    @category = categories.find(params[:id])
    @children =  @category.children
                          .ordered(current_language)
    render 'admin/application/categories/children'
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

  def ensure_xhr
    redirect_to [:admin, categories_class] unless request.xhr?
  end

  def ensure_category_is_editable
    render_forbidden unless @category.editable?
  end
end