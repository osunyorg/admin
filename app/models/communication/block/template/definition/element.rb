class Communication::Block::Template::Definition::Element < Communication::Block::Template::Base
  has_component :title, :string
  has_component :description, :rich_text

  def empty?
    title.blank? && description.blank?
  end

  def dom_count
    2 + description_component.dom_count
  end
end
