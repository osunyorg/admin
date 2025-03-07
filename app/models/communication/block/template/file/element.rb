class Communication::Block::Template::File::Element < Communication::Block::Template::Base

  has_component :title, :string
  has_component :file, :file
  has_component :image, :image

  def blob
    file_component.blob
  end
end
