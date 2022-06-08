class Communication::Block::Template::Base
  class_attribute :components_descriptions,
                  :layouts,
                  :element_class

  attr_reader :block

  def self.has_string(property)
    has_component property, :string
  end

  def self.has_text(property)
    has_component property, :text
  end

  def self.has_rich_text(property)
    has_component property, :rich_text
  end

  def self.has_select(property, **args)
    has_component property, :select
  end

  def self.has_image(property)
    has_component property, :image
  end

  def self.has_layouts(list)
    self.layouts = list
    has_component :layout, :layout
  end

  def self.has_elements(element_class)
    self.element_class = element_class
  end

  def self.has_component(property, kind)
    self.components_descriptions ||= []
    self.components_descriptions << { name: property, type: kind }
    class_eval <<-CODE, __FILE__, __LINE__ + 1

      def #{property}_component
        @#{property}_component ||= Communication::Block::Component::#{kind.to_s.classify}.new(:#{property}, self)
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
    return unless has_elements?
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
    if has_elements?
      hash['elements'] = []
      elements.each do |element|
        hash['elements'] << element.data
      end
    end
    hash
  end

  def git_dependencies
    unless @git_dependencies
      @git_dependencies = []
      components.each do |component|
        add_dependency component.git_dependencies
      end
      elements.each do |element|
        add_dependency element.git_dependencies
      end
      @git_dependencies.uniq!
    end
    @git_dependencies
  end

  def active_storage_blobs
    []
  end

  def has_elements?
    !self.class.element_class.nil?
  end

  def default_element(data = nil)
    return unless has_elements?
    self.class.element_class.new block, data
  end

  def elements
    @elements
  end

  def default_layout
    self.class.layouts&.first
  end

  def layout
    data['layout']
  end

  def kind
    block.template_kind
  end

  def blob_with_id(id)
    university.active_storage_blobs.find id
  end

  def default_data
    {
      'layout' => default_layout,
      'elements' => []
    }
  end

  protected

  def build_git_dependencies
  end

  def add_dependency(dependency)
    if dependency.is_a? Array
      @git_dependencies += dependency
    else
      @git_dependencies += [dependency]
    end
  end

  def components
    return [] if self.class.components_descriptions.nil?
    self.class.components_descriptions.map do |component_description|
      send "#{component_description[:name]}_component"
    end
  end

  def university
    block.university
  end
end
