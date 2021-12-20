module WithInheritance
  extend ActiveSupport::Concern

  included do
    def self.rich_text_areas_with_inheritance(*properties)
      properties.each do |property|
        has_rich_text property
        has_inheritance_methods property
      end
    end

    def self.values_with_inheritance(*properties)
      properties.each do |property|
        has_inheritance_methods property
      end
    end

    def self.has_inheritance_methods(property)
      define_method :"best_#{property}" do
        best(property)
      end
      define_method :"best_#{property}_source" do
        best_source(property)
      end
    end
  end

  protected

  def best(property)
    value = send(property)
    value.blank? ? parent&.send("best_#{property}") : value
  end

  def best_source(property)
    value = send(property)
    return nil if !value.blank? # There is a value, no inheritance needed
    best_value = best(property)
    best_value.is_a?(ActionText::RichText)  ? best_value.record
                                            : ancestors.detect { |ancestor| ancestor.public_send(property) == best_value }
  end
end
