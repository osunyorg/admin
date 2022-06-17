class Communication::Block::Template::Datatable < Communication::Block::Template::Base

  has_elements
  has_component :columns, :array
  has_component :caption, :text

end
