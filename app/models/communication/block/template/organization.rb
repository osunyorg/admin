class Communication::Block::Template::Organization < Communication::Block::Template::Base

  has_elements
  has_layouts [:grid, :map]
  has_component :mode, :option, options: [
    :selection,
    :category
  ]
  has_component :category_id, :organization_category
  has_component :description, :rich_text
  has_component :alphabetical, :boolean
  
  has_component :option_link,         :boolean, default: true
  has_component :option_logo,         :boolean, default: true
  has_component :option_summary,      :boolean, default: false

  def elements
    if alphabetical
      @elements.sort_by! do |element|
        "#{element.best_name&.parameterize&.downcase}"
      end
    end
    @elements
  end

  def dependencies
    selected_elements
  end

  def category
    category_id_component.category
  end

  def organizations
    @organizations ||= selected_elements.collect(&:organization).compact.uniq
  end

  def organization_ids
    @organization_ids ||= organizations.collect(&:id)
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
                              .ordered(block.language)
    organizations.map do |organization|
      # On simule un élément pour l'organisation, afin d'unifier les accès
      Communication::Block::Template::Organization::Element.new(block, {
        'id' => organization.id
      })
    end
  end
end
