class Communication::Block::Component::Option < Communication::Block::Component::Base
  attr_reader :options

  def default_data
    options.first
  end
end
