class Communication::Block::Template::Chapter < Communication::Block::Template
  def build_git_dependencies
    # pas d'images dans summernote, donc rien à déclarer !
  end

  def text
    "#{data['text']}"
  end

  def notes
    "#{data['notes']}"
  end
end
