class Communication::Block::Template::Form < Communication::Block::Template::Base

  has_component :url, :string
  has_component :form_title, :string

  # Quand on ajoutera d'autres plateformes, faire un service comme les vidéos
  def iframe
    "<iframe data-tally-src=\"#{embed_url}\" loading=\"lazy\" width=\"100%\" height=\"100\" frameborder=\"0\" marginheight=\"0\" marginwidth=\"0\" title=\"#{form_title}\"></iframe>"
  end

  def iframe_preview
    "<iframe src=\"#{embed_url}\" loading=\"lazy\" width=\"100%\" height=\"100\" frameborder=\"0\" marginheight=\"0\" marginwidth=\"0\" title=\"#{form_title}\"></iframe>"
  end

  def script
    "<script src=\"https://tally.so/widgets/embed.js\" onload=\"Tally.loadEmbeds()\"></script>"
  end

  def identifier
    @identifier ||= url.remove('https://tally.so/r/')
  end

  def platform
    @platform ||= url.include?('tally.so') ? :tally : nil
  end

  def csp_domains
    [
      'tally.so'
    ]
  end

  protected

  def embed_url
    @embed_url ||= "https://tally.so/embed/#{identifier}?alignLeft=1&hideTitle=1&transparentBackground=1&dynamicHeight=1"
  end
end
