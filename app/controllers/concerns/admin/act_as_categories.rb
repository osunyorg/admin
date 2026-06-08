module Admin::ActAsCategories
  extend ActiveSupport::Concern

  included do
    before_action :ensure_category_is_editable, only: [:edit, :update, :destroy]
    before_action :ensure_xhr, only: [:reorder, :children]
  end

  def reorder
    moved_category_id = params.dig(:itemId)
    moved_category = categories.find(moved_category_id)
    parent_id = params.dig(:parentId).presence

    if moved_category.is_taxonomy? && parent_id.present?
      render plain: I18n.t('admin.categories.cant_move_taxonomy_here'), status: :unprocessable_content
    else
      old_parent_id = params.dig(:oldParentId).presence
      ids = params[:ids] || []
      ids.each.with_index do |id, index|
        category = categories.find(id)
        category.update_columns parent_id: parent_id,
                                position: index + 1
      end
      moved_to_another_parent = old_parent_id != parent_id
      categories_to_touch = []
      categories_to_touch << categories.find(old_parent_id) if old_parent_id.present?
      categories_to_touch << categories.find(parent_id) if parent_id.present?
      categories_to_touch << moved_category
      categories_to_touch.concat(moved_category.descendants) if moved_to_another_parent
      categories_to_touch.uniq.each(&:touch)
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
        :id, :name, :slug, :subtitle, :summary, :meta_description, :breadcrumb_title,
        :header_text, :header_cta, :header_cta_label, :header_cta_url,
        :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
        :shared_image, :shared_image_delete, :shared_image_infos,
        :language_id
      ]).merge(university_id: current_university.id)
  end

  def ensure_xhr
    redirect_to [:admin, categories_class] unless request.xhr?
  end

  def ensure_category_is_editable
    render_forbidden unless @category.editable?
  end
end