class Communication::Block::Template::Embed < Communication::Block::Template::Base

  has_component :code, :code
  has_component :transcription, :text

  protected

  def has_iframe?

    @doc = Nokogiri::XML(code)
    is_iframe = @doc.xpath("//iframe")

    if !is_iframe.empty?
      return true
    end

  end

  def has_iframe_title?
    
    if has_iframe?
      
      Nokogiri::XML(code).at('iframe').attr('title')

    end

  end

  def check_accessibility
    super
    accessibility_error 'accessibility.blocks.templates.embed.title_missing' if  has_iframe? && !has_iframe_without_title?
    accessibility_error 'accessibility.blocks.templates.embed.transcription_missing' if  has_iframe? && transcription.blank?
  end

end
