class Osuny::Search
  attr_reader :term, :university, :language, :website, :extranet

  def initialize(term, university, language, website: nil, extranet: nil)
    @term = term
    @university = university
    @language = language
    @website = website 
    @extranet = extranet
  end

  def results
    term.present? ? build_search_results : Search.none
  end

  protected

  def build_search_results
    results = university.search
                        .for_title(term)
                        .for_language(language)
                        .limit(30)
    if website
      results = results.for_website(website)
    elsif extranet
      results = results.for_extranet(extranet)
    else
      results = results.without_context
    end
    results
  end
end