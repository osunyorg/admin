class Communication::Block::Template::Exhibition::Element < Communication::Block::Template::Base

  has_component :id, :exhibition

  def event
    id_component.event
  end
end
