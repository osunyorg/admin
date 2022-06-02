class Communication::Block::Template::Embed < Communication::Block::Template::Base
  def build_git_dependencies
  end

  def code
    "#{data['code']}"
  end

  def transcription
    "#{data['transcription']}"
  end
end
