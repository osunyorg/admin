class Communication::Block::Template::Organization < Communication::Block::Template::Base

  has_elements
  has_layouts [:grid, :map]
  has_component :mode, :option, options: [
    :selection,
    :category
  ]
  has_component :category_id, :organization_category
  has_component :description, :rich_text
  has_component :with_link, :boolean
  has_component :alphabetical, :boolean

  def elements
    if alphabetical
      @elements.sort_by! do |element|
        "#{element.best_name&.parameterize&.downcase}"
      end
    end
    @elements
  end

  def dependencies
    organizations
  end

  def category
    category_id_component.category
  end

  def organizations
    @organizations ||= elements.collect(&:organization).compact.uniq
  end

  def organization_ids
    @organization_ids ||= @elements.collect(&:organization_id).compact.uniq
  end

  def selected_elements
    @selected_elements ||= send "selected_elements_#{mode}"
  end

  def children
    organizations
  end

  def children_ids
    organization_ids
  end

  protected

  def selected_elements_selection
    elements
  end

  def selected_elements_category
    return [] unless category
    organizations = university.organizations
                              .joins(:categories)
                              .where(categories: {id: category.id } )
                              .distinct
                              .ordered
    organizations.map do |organization|
      # On simule un élément pour l'organisation, afin d'unifier les accès
      Communication::Block::Template::Organization::Element.new(block, {
        'id' => organization.id
      })
    end
  end
end
