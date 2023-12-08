class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.models_with_concern(concern)
    descendants.select { |model|
      model.included_modules.include?(concern)
    }
  end

  def self.model_names_with_concern(concern)
    models_with_concern(concern).map(&:name)
  end
end
