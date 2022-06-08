class Communication::Block::Template::Datatable < Communication::Block::Template::Base

  has_elements Communication::Block::Template::Datatable::Row
  has_array :columns
  has_text :caption

end
