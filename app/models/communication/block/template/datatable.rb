class Communication::Block::Template::Datatable < Communication::Block::Template::Base
  has_array :columns
  has_elements Communication::Block::Template::Datatable::Row
end
