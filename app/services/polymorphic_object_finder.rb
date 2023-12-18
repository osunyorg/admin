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
    model_name = self.safe_model_name(params, key_type, only)
    return if model_name.nil?

    model = model_name.constantize
    id = params[key_id]
    model.where(university: university).find(id)
  end

  private

  # Whitelist user input
  def self.safe_model_name(params, key_type, only)
    only.detect { |item|
      item == params[key_type]
    }
  end
end