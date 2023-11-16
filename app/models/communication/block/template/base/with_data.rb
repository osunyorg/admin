module Communication::Block::Template::Base::WithData
  extend ActiveSupport::Concern

  # Transforms raw json into ruby objects, based on components
  def data=(value)
    json = json_from value
    components.each do |component|
      next unless json.has_key? component.property
      component.data = json[component.property]
    end
    initialize_elements json
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

  def default_data
    hash = {}
    hash['elements'] = [] if has_element_class?
    components.each do |component|
      hash[component.property] = component.default_data
    end
    hash
  end

  def full_text
    unless @full_text
      @full_text = ''
      components.each do |component|
        @full_text += "#{component.full_text}\r"
      end
      if has_element_class?
        elements.each do |element|
          @full_text += "#{element.full_text}\r"
        end
      end
    end
    @full_text
  end

  protected

  def has_element_class?
    !self.class.element_class.nil?
  end

  def initialize_elements(json)
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

  def json_from(value)
    if value.is_a? String
      JSON.parse(value)
    elsif value.is_a? Hash
      value
    else
      default_data
    end
  end

  def components
    return [] if self.class.components_descriptions.nil?
    self.class.components_descriptions.map do |component_description|
      send "#{component_description[:property]}_component"
    end
  end
end
