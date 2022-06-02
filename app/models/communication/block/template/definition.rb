class Communication::Block::Template::Definition < Communication::Block::Template::Base
  def definitions
    @definitions ||= elements.map { |element| definition(element) }
                              .compact
  end

  protected

  def definition(element)
    element.to_dot
  end
end
