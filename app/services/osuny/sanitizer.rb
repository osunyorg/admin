class Osuny::Sanitizer
  include ActionView::Helpers::SanitizeHelper

  self.sanitized_allowed_tags = Rails.application.config.action_view.sanitized_allowed_tags
  self.sanitized_allowed_attributes = Rails.application.config.action_view.sanitized_allowed_attributes

  # type(ActiveRecord) = ['text', 'string']
  def self.sanitize(input, type = 'text')
    return '' if input.blank?
    send "sanitize_#{type}", input
  end

  private

  def self.sanitize_text(input)
    safe_list_sanitizer.sanitize(input)
  end

  def self.sanitize_string(string)
    output = Loofah.fragment(string).text(encode_special_chars: false)
    while output != Loofah.fragment(output).text(encode_special_chars: false)
      output = Loofah.fragment(output).text(encode_special_chars: false)
    end
    output
  end
end
