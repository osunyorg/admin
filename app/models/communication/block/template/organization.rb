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

  def category
    category_id_component.category
  end

  def organizations
    @organizations ||= elements.collect(&:organization).compact.uniq
  end

  def organization_ids
    @organization_ids ||= @elements.collect(&:organization_id).compact.uniq
  end

  def selected_organizations
    @selected_organizations ||= send "selected_organizations_#{mode}"
  end

  def children
    organizations
  end

  def children_ids
    organization_ids
  end

  protected

  def selected_organizations_selection
    elements.map { |element|
      post(element.id)
    }.compact
  end

  def selected_organizations_category
    return [] unless category
    university.organizations.joins(:categories)
                            .where(categories: {id: category.id } )
                            .distinct
                            .ordered

  end
end
