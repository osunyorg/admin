class Communication::Block::Template::Image < Communication::Block::Template::Base

  has_image :image
  has_string :alt
  has_rich_text :credit
  has_text :text

end
