class PolymorphicObjectFinder
  # @block.about = Polymorphic.find(
  #   params,
  #   key: :about,
  #   university: current_university,
  #   only: ["Communication::Website::Page"]
  # )
  # Rails uses ActiveRecord::Inheritance#polymorphic_name to hydrate the about_type.
  # Example: A Block for a Communication::Website::Page::Home will have about_type = "Communication::Website::Page"
  def self.find(params, key:, university:, only: [])
    key_id = "#{key}_id".to_sym
    key_type = "#{key}_type".to_sym
    model_name = only.any? ? only.detect { |item| item == params[key_type] } : params[key_type]
    return if model_name.nil?
    model = model_name.constantize
    id = params[key_id]
    model.where(university: university).find(id)
  end
end