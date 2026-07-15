class Communication::Block::Template::Paper < Communication::Block::Template::Base

  has_elements
  has_component :mode, :option, options: [
    :all,
    :selection
  ]
  has_component :quantity, :number, default: 3

  def dependencies
    selected_papers
  end

  def selected_papers
    @selected_papers ||= send "selected_papers_#{mode}"
  end

  def allowed_for_about?
    website.present? && website.research_papers.any?
  end

  def children
    selected_papers
  end

  def top_link
    l10n = special_page.localization_for(language)
    return nil if l10n.nil?
    l10n.hugo(website).permalink
  end

  protected

  def selected_papers_all
    available_papers.ordered(block.language).limit(quantity)
  end

  def selected_papers_selection
    elements.map { |element|
      paper(element.id)
    }.compact
  end

  def paper(id)
    return if id.blank?
    available_papers.find_by(id: id)
  end

  def available_papers
    website.research_papers
  end

  def special_page
    @special_page ||= website.special_page(Communication::Website::Page::ResearchPaper)
  end
end
