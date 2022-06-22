class Communication::Block::Template::Embed < Communication::Block::Template::Base

  has_component :code, :code
  has_component :transcription, :text

  protected

  def check_accessibility
    super
    accessibility_error 'accessibility.blocks.templates.embed.title_missing' if has_iframe_without_title?
    accessibility_error 'accessibility.blocks.templates.embed.transcription_missing' if  has_iframe? && transcription.blank?
  end

  def has_iframe?
    !nokogiri.xpath("//iframe").empty?
  end

  def has_iframe_without_title?
    return false unless has_iframe?
    nokogiri.at('iframe').attr('title')
  end

  def nokogiri
    @nokogiri ||= Nokogiri::XML(code)
  end

end
