module SimpleForm::CustomInputs
  class TreeInput < SimpleForm::Inputs::CollectionCheckBoxesInput

    def input(wrapper_options = nil)
      html = "<fieldset class=\"mb-3 tree optional #{input_class}\">"
      html += "<input type=\"hidden\" name=\"#{object_name}[#{attribute_name}][]\" value=\"\" autocomplete=\"off\">"
      collection.each do |item|
        html += create_checkbox(item)
      end
      html += "</fieldset>"
      html
    end

    protected

    def create_checkbox(item)
      input_id = "#{object_name}_#{attribute_name}_#{item.id}"
      input_label = item.best_localization_for(language)
      input_checked = selected?(item) ? 'checked="checked"' : ''
      input_with_children = item.children.any?
      html = "<div class=\"form-check\">"
      html += "<input class=\"form-check-input check_boxes optional\" type=\"checkbox\" value=\"#{item.id}\" #{input_checked} name=\"#{object_name}[#{attribute_name}][]\" id=\"#{input_id}\""
      html += " data-bs-toggle=\"collapse\" data-bs-target=\"##{input_id}-children\""
      html += ">"
      html += "<label class=\"form-check-label collection_tree\" for=\"#{input_id}\">#{input_label}</label>"
      if input_with_children
        visible = selected?(item) ? 'show' : ''
        html += "<div id=\"#{input_id}-children\" class=\"collapse #{visible}\">"
        item.children.ordered(language).each do |i|
          html += create_checkbox(i)
        end
        html += "</div>"
      end
      html += "</div>"
      html
    end

    def selected?(item)
      item.id.in?(selected_ids)
    end

    def selected_ids
      @selected_ids ||= object.send(attribute_name)
    end

    def language
      @language ||= options.dig(:language)
    end

  end
end
