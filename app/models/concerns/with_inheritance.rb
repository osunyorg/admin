module WithInheritance
  extend ActiveSupport::Concern

  included do
    def self.rich_text_areas_with_inheritance(*properties)
      properties.each do |property|
        has_summernote property

        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def best_#{property}
            best("#{property}")
          end

          def best_#{property}_source
            best_source("#{property}")
          end
        CODE
      end
    end
  end

  protected

  def best(property)
    value = send(property)
    html = value.nil? ? '' : value.to_html
    Static.blank?(html) ? parent&.send("best_#{property}") : value
  end

  def best_source(property, is_ancestor: false)
    value = send(property)
    return (is_ancestor ? self : nil) if Static.has_content?(value&.to_html)
    parent&.send(:best_source, property, is_ancestor: true)
  end
end
