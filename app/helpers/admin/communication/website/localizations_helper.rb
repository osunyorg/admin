module Admin::Communication::Website::LocalizationsHelper
  def localization_input(f, attribute_name, website)
    label = Communication::Website.human_attribute_name(attribute_name)

    is_editing_master = f.object.is_a?(Communication::Website)
    master_value = website.public_send(attribute_name)
    if !is_editing_master && master_value.present?
      hint = t('admin.communication.website.localizations.fallback_hint_html', master_value: master_value)
    else
      hint = nil
    end

    f.input attribute_name,
            label: label,
            hint: hint
  end
end