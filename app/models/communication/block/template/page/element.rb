class Communication::Block::Template::Page::Element < Communication::Block::Template::Base

  has_component :id, :page

  def page
    id_component.page
  end
end
