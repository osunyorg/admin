class Communication::Block::Template::File::Element < Communication::Block::Template::Base

  has_component :title, :string
  has_component :file, :file

  def blob
    file_component.blob
  end
end
