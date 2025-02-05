class Communication::Block::Template::Volume < Communication::Block::Template::Base

  has_elements
  has_component :mode, :option, options: [
    :all,
    :selection
  ]
  has_component :quantity, :number, default: 3

  def dependencies
    selected_volumes
  end

  def selected_volumes
    @selected_volumes ||= send "selected_volumes_#{mode}"
  end

  def allowed_for_about?
    website.present? && website.research_volumes.any?
  end

  def children
    selected_volumes
  end

  def top_link
    return unless mode == 'all'
    link_to_special_page
  end

  protected

  def link_to_special_page
    special_page_l10n = special_page.localization_for(block.language)
    permalink_for(special_page_l10n)
  end

  def permalink_for(l10n)
    return if l10n.nil?
    hugo = l10n.hugo(website)
    hugo.permalink
  end

  def selected_volumes_all
    available_volumes.ordered(block.language).limit(quantity)
  end

  def selected_volumes_selection
    elements.map { |element|
      volume(element.id)
    }.compact
  end

  def volume(id)
    return if id.blank?
    available_volumes.find_by(id: id)
  end

  def available_volumes
    website.research_volumes
  end

  def special_page
    @special_page ||= website.special_page(Communication::Website::Page::ResearchVolume)
  end
end
