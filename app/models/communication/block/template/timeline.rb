class Communication::Block::Template::Timeline < Communication::Block::Template

  def description
    "#{data['description']}"
  end

  def events
    @events ||= elements.map { |element| event(element) }
                              .compact
  end

  protected

  def event(element)
    element.to_dot
  end
end
