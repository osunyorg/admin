class Communication::Block::Template::Exhibition::Element < Communication::Block::Template::Base

  has_component :id, :exhibition

  def exhibition
    id_component.exhibition
  end
end
