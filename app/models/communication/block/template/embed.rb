class Communication::Block::Template::Embed < Communication::Block::Template::Base

  has_component :code, :text
  has_component :iframe_title, :string
  has_component :transcription, :text

end
