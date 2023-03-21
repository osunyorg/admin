class Polymorphic
  # Rails uses ActiveRecord::Inheritance#polymorphic_name to hydrate the about_type.
  # Example: A Block for a Communication::Website::Page::Home will have about_type = "Communication::Website::Page"
  def self.find(params, key)
    key_id = "#{key}_id".to_sym
    key_type = "#{key}_type".to_sym
    klass = params[key_type].constantize
    id = params[key_id]
    klass.find id
  end
end