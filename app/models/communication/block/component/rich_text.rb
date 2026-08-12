class Communication::Block::Component::RichText < Communication::Block::Component::Base

  def data=(value)
    value = SummernoteCleaner.clean value.to_s
    value = Osuny::Sanitizer.sanitize value, 'text'
    @data = value
  end

  # Add whitespace between tags https://stackoverflow.com/a/28449868
  # strip_tags does not work because it removes all tags and joins text together without spaces
  def full_text
    nokogiri.xpath('//text()').map(&:text).join(' ')
  end

  def dom_count
    nokogiri.css('*').count
  end

  protected

  def nokogiri
    @nokogiri ||= Nokogiri::HTML(data)
  end
end
