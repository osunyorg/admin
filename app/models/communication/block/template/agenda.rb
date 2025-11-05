class Communication::Block::Template::Agenda < Communication::Block::Template::Base

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
  has_component :no_event_message, :string

  # Options d'affichage
  has_component :option_categories,   :boolean, default: false
  has_component :option_dates,        :boolean, default: true
  has_component :option_image,        :boolean, default: true
  has_component :option_subtitle,     :boolean, default: true
  has_component :option_summary,      :boolean, default: true
  has_component :option_status,       :boolean, default: false

  # Choix des types d'événements
  has_component :kind_parent,         :boolean, default: false
  has_component :kind_child,          :boolean, default: true
  has_component :kind_recurring,      :boolean, default: true

  # Can send events or timeslots
  def selected_events
    @selected_events ||= send("selected_events_#{mode}")
  end

  def category
    return unless mode == 'category'
    category_id_component.category
  end

  def dependencies
    selected_events
  end

  def allowed_for_about?
    website.present? && website.feature_agenda
  end

  def children
    selected_events
  end

  def empty?
    selected_events.none? &&
    no_event_message.blank? &&
    mode != 'categories'
  end

  def title_link
    return link_to_category if category.present?
    return link_to_events if mode == 'all'
    nil
  end

  def top_link
    title_link
  end

  protected

  def selected_events_all
    planner.to_array
  end

  def selected_events_category
    planner.to_array
  end

  def planner
    @planner ||= Communication::Website::Agenda::Planner.new(
      website: website,
      time_scope: time,
      options: {
        category: category,
        quantity: quantity,
        language: block.language,
      },
      including: {
        parents: kind_parent,
        children: kind_child,
        recurring: kind_recurring
      }
    )
  end

  # Not filtered, no timeslots (yet)
  def selected_events_selection
    elements.map { |element|
      element.event
    }.compact
  end

  def link_to_events
    special_page_l10n = events_special_page.localization_for(block.language)
    permalink_for(special_page_l10n)
  end

  def link_to_category
    category_l10n = category.localization_for(block.language)
    permalink_for(category_l10n)
  end

  def events_special_page
    website.special_page(Communication::Website::Page::CommunicationAgenda)
  end

  def permalink_for(l10n)
    return if l10n.nil?
    hugo = l10n.hugo(website)
    hugo.permalink
  end
end
