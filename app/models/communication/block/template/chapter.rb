class Communication::Block::Template::Chapter < Communication::Block::Template::Base

  has_rich_text :text
  has_rich_text :notes
  has_image :image
  has_string :alt
  has_rich_text :credit

end
