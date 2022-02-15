module WithInheritance
  extend ActiveSupport::Concern

  included do
    def self.rich_text_areas_with_inheritance(*properties)
      properties.each do |property|
        has_rich_text property
        has_summernote :"#{property}_new"

        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def best_#{property}
            best("#{property}")
          end

          def best_#{property}_source
            best_source("#{property}")
          end

          def best_#{property}_new
            value = send("#{property}_new")
            value.blank? ? parent&.best_#{property}_new : value
          end

          def best_#{property}_new_source(is_ancestor: false)
            value = send("#{property}_new")
            return (is_ancestor ? self : nil) if value.present?
            parent&.best_#{property}_new_source(is_ancestor: true)
          end
        CODE
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
    best(property)&.record
  end
end
