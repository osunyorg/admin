class PolymorphicObjectFinder
  # PolymorphicObjectFinder.find(
  #   params,
  #   key: :about,
  #   university: current_university,
  #   mandatory_module: Contentful
  # )
  # Rails uses ActiveRecord::Inheritance#polymorphic_name to hydrate the about_type.
  # Example: A Block for a Communication::Website::Page::Home will have about_type = "Communication::Website::Page"
  def self.find(params, key:, university:, mandatory_module: nil, permitted_classes: [])
    finder = new  params, 
                  key: key, 
                  university: university, 
                  mandatory_module: mandatory_module, 
                  permitted_classes: permitted_classes
    finder.object
  end

  def object
    return unless complies_with_mandatory_module? && complies_with_permitted_classes?
    model.where(university: university).find(object_id)
  end
  
  private

  attr_reader :params, :key, :university, :mandatory_module, :permitted_classes

  def initialize(params, key:, university:, mandatory_module: , permitted_classes: )
    @params             = params
    @key                = key
    @university         = university
    @mandatory_module   = mandatory_module
    @permitted_classes  = permitted_classes
  end

  def key_id
    "#{key}_id".to_sym
  end
  
  def key_type
    "#{key}_type".to_sym
  end

  def model_name
    params[key_type]
  end

  def object_id
    params[key_id]
  end

  def model
    # Constantize will raise an exception if failed
    model_name.constantize
  end

  def complies_with_mandatory_module?
    return true if mandatory_module.nil?
    model_includes_module?
  end

  def complies_with_permitted_classes?
    return true if permitted_classes.empty?
    model.in? permitted_classes
  end

  def model_includes_module?
    model.included_modules.include?(mandatory_module)
  end
end