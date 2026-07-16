class Communication::Block::Template::File::Element < Communication::Block::Template::Base

  has_component :title, :string
  has_component :file, :file
  has_component :image, :image

  def blob
    file_component.blob
  end

  def communication_file
    file_component.communication_file
  end
  
  def dom_count
    2 +
    file_component.blob_count +
    image_component.blob_count
  end
end
