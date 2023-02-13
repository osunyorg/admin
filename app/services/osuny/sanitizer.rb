class Osuny::Sanitizer
  include ActionView::Helpers::SanitizeHelper

  ALLOWED_TAGS = [
    "a", "b", "br", "em", "i", "img", "li", "ol", "p", "strong", "sub", "sup", "ul"
  ]

  ALLOWED_ATTRIBUTES = [
    "href", "target", "title"
  ]

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
