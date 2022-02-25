class Osuny::Sanitizer
  include ActionView::Helpers::SanitizeHelper

  def self.sanitize(input, type = 'text')
    return '' if input.blank?
    raise ArgumentError.new('First argument must be a String') unless [String, ActionText::Content].include? input.class

    case type.to_s
    when 'string'
      string_sanitize(input)
    when 'text'
      if input.is_a? String
        safe_list_sanitizer.sanitize input
      else
        ActionText::Content.new(safe_list_sanitizer.sanitize input.to_html)
      end
    else
      input
    end
  end

  private

  def self.string_sanitize(raw_string)
    output = Loofah.fragment(raw_string).text(encode_special_chars: false)
    while output != Loofah.fragment(output).text(encode_special_chars: false)
      output = Loofah.fragment(output).text(encode_special_chars: false)
    end
    output
  end
end
