class Communication::Block::Template::Gallery::Image < Communication::Block::Template::Base
  has_image :image
  has_string :alt
  has_rich_text :credit
  has_rich_text :text

  def default_data
    {
      'alt' => '',
      'credit' => '',
      'file' => {}
    }
  end
end
