module RelationsLanguageIntegrity
  extend ActiveSupport::Concern

  protected

  def ensure_connected_elements_are_in_correct_language
    raise NotImplementedError
  end

  def ensure_single_connection_is_in_correct_language(element, property_name, compared_language = language)
    return unless element.present? && element.language_id != compared_language.id
    element_in_correct_language = element.find_or_translate!(compared_language)
    public_send("#{property_name}=", element_in_correct_language.id)
  end

  def ensure_multiple_connections_are_in_correct_language(elements, property_name, compared_language = language)
    correct_elements_ids = []
    elements.each do |element|
      if element.language_id == compared_language.id
        element_in_correct_language = element
      else
        element_in_correct_language = element.find_or_translate!(compared_language)
      end
      correct_elements_ids << element_in_correct_language.id
    end
    public_send("#{property_name}=", correct_elements_ids)
  end

end