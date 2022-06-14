class Communication::Block::Template::Gallery::Image < Communication::Block::Template::Base
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text
  has_component :text, :text

  def blob
    image_component.blob
  end
end
