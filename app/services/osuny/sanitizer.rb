class Osuny::Sanitizer
  include ActionView::Helpers::SanitizeHelper

  # type(ActiveRecord) = ['text', 'string']
  def self.sanitize(input, type = 'text')
    return '' if input.blank?
    send "sanitize_#{type}", input
  end

  private

  # input can be String or ActionText::Content
  def self.sanitize_text(input)
    input.is_a?(String) ? safe_list_sanitizer.sanitize(input)
                        : ActionText::Content.new(
                            safe_list_sanitizer.sanitize(input.to_html)
                          )
  end

  def self.sanitize_string(string)
    output = Loofah.fragment(string).text(encode_special_chars: false)
    while output != Loofah.fragment(output).text(encode_special_chars: false)
      output = Loofah.fragment(output).text(encode_special_chars: false)
    end
    output
  end
end
