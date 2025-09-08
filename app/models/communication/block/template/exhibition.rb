class Communication::Block::Template::Exhibition < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :grid,
    :list,
    :large
  ]
  has_component :mode, :option, options: [
    :all,
    :category,
    :selection
  ]
  has_component :category_id, :agenda_category
  has_component :description, :rich_text
  has_component :quantity, :number, default: 3
  has_component :time, :option, options: Communication::Website::Agenda::AUTHORIZED_SCOPES
  has_component :no_exhibition_message, :string

  # Options d'affichage
  has_component :option_categories,   :boolean, default: false
  has_component :option_dates,        :boolean, default: true
  has_component :option_image,        :boolean, default: true
  has_component :option_subtitle,     :boolean, default: true
  has_component :option_summary,      :boolean, default: true
  has_component :option_status,       :boolean, default: false

  def selected_exhibitions
    @selected_exhibitions ||= send "selected_exhibitions_#{mode}"
  end

  def category
    category_id_component.category
  end

  def dependencies
    selected_exhibitions
  end

  def allowed_for_about?
    website.present? && website.feature_agenda
  end

  def children
    selected_exhibitions
  end

  def empty?
    selected_exhibitions.none? &&
    no_exhibition_message.blank? &&
    mode != 'categories'
  end

  def title_link
    return link_to_category if mode == 'category' && category.present?
    return link_to_exhibitions if mode == 'all'
    nil
  end

  def top_link
    title_link
  end

  protected

  def link_to_exhibitions
    special_page_l10n = exhibitions_special_page.localization_for(block.language)
    permalink_for(special_page_l10n)
  end

  def link_to_category
    category_l10n = category.localization_for(block.language)
    permalink_for(category_l10n)
  end

  def exhibitions_special_page
    website.special_page(Communication::Website::Page::CommunicationAgendaExhibition)
  end

  def permalink_for(l10n)
    return if l10n.nil?
    hugo = l10n.hugo(website)
    hugo.permalink
  end

  def base_exhibitions
    exhibitions = website_and_federated_exhibitions
    if time.in?(Communication::Website::Agenda::AUTHORIZED_SCOPES)
      exhibitions = exhibitions.public_send(time)
      exhibitions = time == 'archive' ? exhibitions.ordered_desc : exhibitions.ordered_asc
    end
    exhibitions
  end

  def selected_exhibitions_all
    base_exhibitions.first(quantity)
  end

  def selected_exhibitions_category
    exhibitions = base_exhibitions
    exhibitions = exhibitions.for_category(category) if category
    exhibitions.first(quantity)
  end

  def selected_exhibitions_selection
    elements.map { |element|
      element.exhibition
    }.compact
  end

  def website_and_federated_exhibitions
    Communication::Website::Agenda::Exhibition.where(id: website_and_federated_exhibition_ids)
                                              .published_now_in(block.language)
  end

  def website_and_federated_exhibition_ids
    @website_and_federated_exhibition_ids ||= (
      website.exhibitions.pluck(:id) +
      website.federated_communication_website_agenda_exhibitions.pluck(:id)
    )
  end
end
