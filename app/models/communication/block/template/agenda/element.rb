class Communication::Block::Template::Agenda::Element < Communication::Block::Template::Base

  has_component :id, :event

  def event
    id_component.event
  end
end
