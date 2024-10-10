module ApplicationHelper

  def controller_class
    "#{controller_name.gsub('/', '--')}"
  end

  def body_classes
    classes = "controller-#{controller_class}"
    classes += " action-#{action_name}"
    classes += " #{controller_class}-#{action_name}"
    classes
  end

  def contact_link(string, kind)
    service = ContactDetails.for(kind, string)
    sanitize "<a href=\"#{service.value}\" target=\"_blank\" rel=\"noreferrer\">#{service.label}</a>"
  end

  def masked_email(string)
    string.gsub(/(?<=.{2}).*@.*(?=\S{2})/, '****@****')
  end

  def masked_phone(string)
    string.gsub(/(?<=.{3}).+(?=.{2})/, '*******')
  end

  def masked_string(string)
    string = string.to_s # in case it was nil
    mask_length = [(string.length - 5), 0].max
    mask_length = 30 if mask_length > 30
    string.to_s.gsub(/.+(?=.{5})/, '•' * mask_length)
  end

  def language_name(iso_code)
    I18nData.languages(I18n.locale)[iso_code.to_s.upcase].titleize
  end

  def best_value(object, key)
    object.best_value(:key, current_language)
  end

  def default_images_formats_accepted
    Rails.application.config.default_images_formats.join(', ')
  end
  
  def default_audio_formats_accepted
    Rails.application.config.default_audio_formats.join(', ')
  end

  def file_hint(filesize: number_to_human_size(Rails.application.config.default_file_max_size), formats: [])
    if formats.empty?
      t('file_hint_without_formats', filesize: filesize)
    else
      t('file_hint_with_formats', filesize: filesize, formats: formats)
    end
  end

  def images_formats_accepted_hint(formats: default_images_formats_accepted)
    file_hint(filesize: number_to_human_size(Rails.application.config.default_image_max_size), formats: formats)
  end
  
  def audio_formats_accepted_hint(formats: default_audio_formats_accepted)
    file_hint(formats: formats)
  end

  def prepare_notes(text)
    @notes ||= Osuny::Notes.new
    @notes.prepare(text)
  end

end
