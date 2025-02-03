class Communication::Block::Template::Category::Element < Communication::Block::Template::Base

  has_component :id, :category

  def category
    id_component.category
  end
end
