class Communication::Block::Template::Datatable::Element < Communication::Block::Template::Base

  has_component :cells, :array

  def dom_count
    cells_component.dom_count
  end
end
