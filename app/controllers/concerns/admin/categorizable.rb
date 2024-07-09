module Admin::Categorizable
  extend ActiveSupport::Concern

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
      old_parent.sync_with_git
    end
    categories.find(params[:itemId]).sync_with_git # Will sync siblings
  end

  def children
    return unless request.xhr?
    @categories_class = categories_class
    @category = categories.find(params[:id])
    @children = @category.children.ordered
    render 'admin/application/categories/children'
  end

  protected

  # Good for websites, but needs override for other objects
  def categories
    categories_class.where(communication_website_id: @website.id)
                   .tmp_original
                   .ordered
  end

  # Communication::Website::Agenda::Category
  def categories_class
    raise NoMethodError.new("categories_class must be implemented in the controller, for example Communication::Website::Agenda::Category")
  end
end