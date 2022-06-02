class Communication::Block::Template::KeyFigure < Communication::Block::Template::Base
  def build_git_dependencies
  end

  def figures
    @figures ||= elements.map { |element| figure(element) }
                              .compact
  end

  protected

  def figure(element)
    element.to_dot
  end
end
