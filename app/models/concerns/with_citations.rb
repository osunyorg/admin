module WithCitations
  extend ActiveSupport::Concern

  def citation_apa(website: nil)
    citation_for("apa", website: website)
  end

  def citation_iso690(website: nil)
    citation_for("iso690-author-date-fr-no-abstract", website: website)
  end

  def citation_mla(website: nil)
    citation_for("modern-language-association", website: website)
  end

  protected

  def citation_for(style, website: nil)
    citeproc = to_citeproc(website: website)
    processor = CiteProc::Processor.new style: style, format: 'text'
    processor.import([citeproc])
    processor.render(:bibliography, id: citeproc["id"]).first
  end

  def to_citeproc(website: nil)
    raise NotImplementedError
  end
end