class Communication::Block::Component::Base
  attr_reader :property, :template

  def initialize(property, template)
    @property = property.to_s
    @template = template
  end

  def data
    @data
  end

  def data=(value)
    @data = value
  end
end
