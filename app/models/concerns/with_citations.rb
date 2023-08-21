module WithCitations
  extend ActiveSupport::Concern

  def citation_apa(website: nil, locale: nil)
    citation_for("apa", website: website, locale: locale)
  end

  def citation_iso690(website: nil, locale: nil)
    citation_for("iso690-author-date-fr-no-abstract", website: website, locale: locale)
  end

  def citation_mla(website: nil, locale: nil)
    citation_for("modern-language-association", website: website, locale: locale)
  end

  def citation_chicago(website: nil, locale: nil)
    citation_for("chicago-author-date", website: website, locale: locale)
  end

  def citation_harvard(website: nil, locale: nil)
    citation_for("harvard-cite-them-right", website: website, locale: locale)
  end

  protected

  def citation_for(style, website: nil, locale: nil)
    citeproc = to_citeproc(website: website)
    processor = CiteProc::Processor.new style: style, format: 'html', locale: locale
    processor.import([citeproc])
    processor.render(:bibliography, id: citeproc["id"]).first
  end

  def to_citeproc(website: nil)
    raise NotImplementedError
  end
end