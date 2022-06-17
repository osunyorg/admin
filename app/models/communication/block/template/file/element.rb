class Communication::Block::Template::File::File < Communication::Block::Template::Base

  has_component :title, :string
  has_component :file, :file

end
