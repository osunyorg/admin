module Education::Program::Localization::WithInheritance
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
    Static.blank?(value.to_s) ? search_above(property) : value
  end
  
  def search_above(property)
    if parent.present? 
      parent.send("best_#{property}")
    elsif diploma.present? && diploma.respond_to?(property)
      diploma.send(property)
    end
  end

  def best_source(property, is_ancestor: false)
    value = send(property)
    if Static.has_content?(value.to_s)
      # Le contenu vient de cette formation
      # Si c'est un ancêtre (via appel récursif), c'est bien la meilleure source
      # Si ce n'est pas un ancêtre, c'est que la formation a sa propre donnée, et il n'y a pas de meilleure source
      is_ancestor ? self : nil
    else
      search_source_above(property)
    end
  end

  def search_source_above(property)
    if parent.present?
      # Appel récursif, on n'a pas trouvé, on remonte la parentèle
      parent&.send(:best_source, property, is_ancestor: true)
    elsif is_diploma_source?(property)
      diploma
    end
  end

  def is_diploma_source?(property)
    return false if diploma.nil?
    return false unless diploma.respond_to?(property)
    value = diploma.send(property)
    Static.has_content?(value.to_s)
  end
end
