class Communication::Block::Component::Base
  include WithAccessibility
  include WithDependencies

  attr_reader :property, :template

  def self.openapi_property_type
    :string
  end

  def self.openapi_property_format
    nil
  end

  def self.openapi_property_additional_properties
    {}
  end

  def initialize(property, template, options: nil, default: nil)
    @property = property.to_s
    @template = template
    @options = options
    @default = default
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

  def university
    template.block.university
  end

  def website
    template.block.about&.website
  end

  def full_text
    ''
  end

  def to_s
    self.class.to_s.demodulize
  end

end
