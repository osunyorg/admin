class Communication::Block::Template::Chapter < Communication::Block::Template::Base

  has_rich_text :text
  has_rich_text :notes
  has_image :image
  has_string :image_alt
  has_rich_text :image_credit

end
