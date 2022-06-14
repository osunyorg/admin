class Communication::Block::Template::Datatable < Communication::Block::Template::Base

  has_elements Communication::Block::Template::Datatable::Row
  has_component :columns, :array
  has_component :caption, :text

end
