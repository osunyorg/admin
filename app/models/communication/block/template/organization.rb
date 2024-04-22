class Communication::Block::Template::Organization < Communication::Block::Template::Base

  has_elements
  has_layouts [:grid, :map]
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

  def organizations
    @organizations ||= elements.collect(&:organization).compact.uniq
  end

  def organization_ids
    @organization_ids ||= @elements.collect(&:organization_id).compact.uniq
  end

  def children
    organizations
  end

  def children_ids
    organization_ids
  end
end
