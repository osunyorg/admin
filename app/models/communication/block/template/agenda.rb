class Communication::Block::Template::Agenda < Communication::Block::Template::Base

  AUTHORIZED_SCOPES = [
    'future_or_current',
    'future',
    'current',
    'archive'
  ]

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
  has_component :time, :option, options: AUTHORIZED_SCOPES
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

  def selected_events
    unless @selected_events
      events = send "selected_events_#{mode}"
      @selected_events = filter(events)
    end
    @selected_events
  end

  def category
    category_id_component.category
  end

  def dependencies
    selected_events
  end

  def allowed_for_about?
    website.present?
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
    return link_to_category if mode == 'category' && category.present?
    return link_to_events if mode == 'all'
    nil
  end

  def top_link
    title_link
  end

  protected

  def filter(events)
    list = []
    events.each do |event|
      list << event unless event_forbidden?(event)
      break if list.count >= quantity
    end
    list
  end

  def event_forbidden?(event)
    (event.kind_parent? && !kind_parent) ||
    (event.kind_child? && !kind_child) ||
    (event.kind_recurring? && !kind_recurring)
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

  def base_events
    events = website.events.published_now_in(block.language)
    if time.in?(AUTHORIZED_SCOPES)
      events = events.public_send(time)
      events = time == 'archive' ? events.ordered_desc : events.ordered_asc
    end
    events
  end

  def selected_events_all
    base_events
  end

  def selected_events_category
    events = base_events
    events = events.for_category(category) if category
    events
  end

  def selected_events_selection
    elements.map { |element|
      element.event
    }.compact
  end

  def selected_events_categories
    []
  end

end
