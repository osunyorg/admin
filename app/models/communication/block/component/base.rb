class Communication::Block::Component::Base
  attr_reader :property, :template

  def initialize(property, template)
    @property = property.to_s
    @template = template
  end

  def value
    data[property]
  end

  def value=(v)
    data[property] = v
  end

  def data
    template.data
  end
end
