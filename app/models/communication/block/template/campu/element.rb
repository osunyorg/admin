class Communication::Block::Template::Campu::Element < Communication::Block::Template::Base

  has_component :id, :location

  def location
    id_component.location
  end
end
