module University::PeopleHelper

  def personal_data_visibility_input_options
    {
      as: :radio_buttons,
      wrapper: :vertical_collection_inline_with_items_wrapper,
      wrapper_html: { class: "visibility_radio_buttons" },
      label_method: -> (option) { t("university.person.personal_data_visibilities.#{option[1]}") },
      hint: t('simple_form.hints.university_person.personal_data_visibility')
    }
  end

  def personal_attribute_visibility_tag(visibility_value)
    label = t("university.person.personal_data_visibilities.#{visibility_value}")
    hint_text = t("simple_form.hints.university_person.personal_data_visibility")
    color_class_name =  case visibility_value
                        when 'public'
                          'bg-primary'
                        when 'restricted'
                          'bg-warning'
                        else
                          'bg-danger'
                        end
    content_tag(:span, label, class: "badge #{color_class_name}", title: hint_text) if visibility_value.present?
  end

end