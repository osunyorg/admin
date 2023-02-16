class Communication::Block::Template::Program < Communication::Block::Template::Base

  has_elements

  def direct_dependencies
    selected_programs
  end

  def selected_programs
    @selected_programs ||= elements.map { |element| element.program }.compact
  end

end
