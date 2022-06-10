class Communication::Block::Template::Embed < Communication::Block::Template::Base

  has_text :code
  has_string :iframe_title
  has_text :transcription

end
