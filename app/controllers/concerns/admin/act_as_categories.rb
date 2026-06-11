module Admin::ActAsCategories
  extend ActiveSupport::Concern

  included do
    before_action :ensure_category_is_editable, only: [:edit, :update, :destroy]
    before_action :ensure_xhr, only: [:reorder, :children]
  end

  def reorder
    result = categories_class.reorder_categories(
      categories: categories,
      item_id: params[:itemId],
      previous_parent_id: params[:oldParentId], 
      parent_id: params[:parentId], 
      ids: params[:ids]
    )
    if result
      head :ok
    else
      render plain: I18n.t('admin.categories.cant_move_taxonomy_here'), status: :unprocessable_content
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