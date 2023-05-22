class Communication::Block::Component::Base
  include Accessible
  include WithDependencies

  attr_reader :property, :template

  def initialize(property, template, options = nil)
    @property = property.to_s
    @template = template
    @options = options
  end

  def default_data
    ''
  end

  def data
    @data || default_data
  end

  def data=(value)
    @data = value
  end

  def kind
    self.class.name.demodulize.underscore
  end

  def website
    template.block.about&.website
  end

  def translate!
    # By default, does nothing. Specific cases are handled in their own definitions. (example: post)
  end

  def to_s
    self.class.to_s.demodulize
  end
end
