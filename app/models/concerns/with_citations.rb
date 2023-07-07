module WithCitations
  extend ActiveSupport::Concern

  def citation_apa(website)
    citation_for(website, "apa")
  end

  def citation_iso690(website)
    citation_for(website, "iso690-author-date-fr-no-abstract")
  end

  def citation_mla(website)
    citation_for(website, "modern-language-association")
  end

  protected

  def citeproc_for_website(website)
    raise NotImplementedError
  end

  def citation_for(website, style)
    citeproc = citeproc_for_website(website)
    processor = CiteProc::Processor.new style: style, format: 'text'
    processor.import([citeproc])
    processor.render(:bibliography, id: citeproc["id"]).first
  end
end