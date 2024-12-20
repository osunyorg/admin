class Communication::Block::Template::Base
  include WithAccessibility
  include WithData
  include WithDependencies
  include WithTop

  class_attribute :components_descriptions,
                  :layouts,
                  :element_class

  attr_reader :block, :elements

  delegate :university, to: :block
  delegate :about, to: :block
  delegate :language, to: :block
  delegate :template_kind, to: :block
  alias :kind :template_kind

  def self.has_elements(element_class = nil)
    element_class = "#{self}::Element".constantize if element_class.nil?
    self.element_class = element_class
  end

  def self.has_layouts(property)
    self.layouts = property
    has_component :layout, :layout
  end

  def self.has_component(property, kind, options: nil, default: nil)
    self.components_descriptions ||= []
    self.components_descriptions << {
      property: property,
      kind: kind,
      options: options,
      default: default
    }
    class_eval <<-CODE, __FILE__, __LINE__ + 1

      def #{property}_component
        @#{property}_component ||= build_component(:#{property})
      end

      def #{property}
        #{property}_component.data
      end

      def #{property}=(value)
        #{property}_component.data = value
      end

    CODE
  end

  # It can be initialized with no data, for a full block
  # or with data provided, for nested elements
  def initialize(block, json)
    @block = block
    @elements = []
    self.data = json
  end

  def dependencies
    components + elements
  end

  def default_element(data = nil)
    return unless has_element_class?
    self.class.element_class.new block, data
  end

  def default_layout
    self.class.layouts&.first
  end

  def allowed_for_about?
    true
  end

  def children
    false
  end

  def empty?
    false
  end

  # Called before block validation
  # Has an override in some templates (video)
  def before_validation
  end

  def to_s
    self.class.to_s.demodulize
  end

  protected

  def build_component(property)
    hash = self.class.components_descriptions.detect do |hash|
      hash[:property] == property
    end
    component_class = "Communication::Block::Component::#{hash[:kind].to_s.classify}".constantize
    component_class.new hash[:property],
                        self,
                        options: hash[:options],
                        default: hash[:default]
  end

  def check_accessibility
    accessibility_merge_array components
    accessibility_merge_array elements
  end

  def website
    about&.try(:website)
  end
end
