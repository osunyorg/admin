class Communication::Block::Template::Video < Communication::Block::Template::Base
  has_string :url
  has_string :video_title
  has_text :transcription

  def build_git_dependencies
  end
end
