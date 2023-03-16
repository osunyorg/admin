class Communication::Block::Template::Partner < Communication::Block::Template::Base

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
end
