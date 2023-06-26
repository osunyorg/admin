class Communication::Block::Template::Base
  include WithAccessibility
  include WithDependencies

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

  def self.has_component(property, kind, options: nil)
    self.components_descriptions ||= []
    self.components_descriptions << {
      property: property,
      kind: kind,
      options: options
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

  # Transforms raw json into ruby objects, based on components
  def data=(value)
    if value.is_a? String
      json = JSON.parse(value)
    elsif value.is_a? Hash
      json = value
    else
      json = default_data
    end
    components.each do |component|
      next unless json.has_key? component.property
      component.data = json[component.property]
    end
    return unless has_element_class? # Template is not supposed to have elements at all
    return unless json.has_key?('elements') # Template has no element yet
    # Objects are initialized from the database,
    # then data from the form replaces data from the db.
    # We need to reset elements, otherwise it's never deleted.
    @elements = []
    json['elements'].each do |json|
      @elements << default_element(json)
    end
  end

  # Reads the data from the components
  def data
    hash = default_data
    components.each do |component|
      hash[component.property] = component.data
    end
    if has_element_class?
      hash['elements'] = []
      elements.each do |element|
        hash['elements'] << element.data
      end
    end
    hash
  end

  def translate!
    components.each(&:translate!)
    elements.each(&:translate!) if has_element_class?
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

  def default_data
    hash = {}
    hash['elements'] = [] if has_element_class?
    components.each do |component|
      hash[component.property] = component.default_data
    end
    hash
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
                        hash[:options]
  end

  def check_accessibility
    accessibility_merge_array components
    accessibility_merge_array elements
  end

  def has_element_class?
    !self.class.element_class.nil?
  end

  def components
    return [] if self.class.components_descriptions.nil?
    self.class.components_descriptions.map do |component_description|
      send "#{component_description[:property]}_component"
    end
  end

  def website
    about&.try(:website)
  end
end
