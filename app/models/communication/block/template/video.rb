class Communication::Block::Template::Video < Communication::Block::Template
  has_string :url
  has_text :transcription

  def build_git_dependencies
  end
end
