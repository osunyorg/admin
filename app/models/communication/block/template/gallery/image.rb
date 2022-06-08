class Communication::Block::Template::Gallery::Image < Communication::Block::Template::Base
  has_image :image
  has_string :alt
  has_rich_text :credit
  has_text :text

  def blob
    image_component.blob
  end
end
