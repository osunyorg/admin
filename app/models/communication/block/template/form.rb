class Communication::Block::Template::Form < Communication::Block::Template::Base

  has_component :url, :string
  has_component :form_title, :string

  def iframe
    @iframe ||= tally_iframe + tally_script
  end

  def identifier
    url.remove('https://tally.so/r/')
  end

  def platform
    url.include?('tally.so') ? :tally : nil
  end

  protected

  # Quand on ajoutera d'autres plateformes, faire un service comme les vidéos
  def tally_iframe
    "<iframe data-tally-src=\"https://tally.so/embed/#{identifier}?alignLeft=1&hideTitle=1&transparentBackground=1&dynamicHeight=1\" loading=\"lazy\" width=\"100%\" height=\"589\" frameborder=\"0\" marginheight=\"0\" marginwidth=\"0\" title=\"#{form_title}\"></iframe>\n"
  end

  def tally_script
    "<script src=\"https://tally.so/widgets/embed.js\" onload=\"Tally.loadEmbeds()\"></script>"
  end
end
