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

  def communication_file_l10n
    communication_file.localization_for(block.language)
  end
  
  def dom_count
    2 +
    file_component.dom_count +
    image_component.dom_count
  end
end
