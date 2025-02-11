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

  has_component :option_categories,   :boolean, default: false
  has_component :option_dates,        :boolean, default: true
  has_component :option_image,        :boolean, default: true
  has_component :option_subtitle,     :boolean, default: true
  has_component :option_summary,      :boolean, default: true
  has_component :option_status,       :boolean, default: false

  def selected_events
    @selected_events ||= send "selected_events_#{mode}"
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
    return link_to_events_archive if time == 'archive'
    return link_to_category if mode == 'category' && category.present?
    return link_to_events if mode == 'all'
    nil
  end

  def top_link
    title_link
  end

  protected

  def link_to_events
    special_page_l10n = events_special_page.localization_for(block.language)
    permalink_for(special_page_l10n)
  end

  def link_to_events_archive
    special_page_l10n = events_archive_special_page.localization_for(block.language)
    permalink_for(special_page_l10n)
  end

  def link_to_category
    category_l10n = category.localization_for(block.language)
    permalink_for(category_l10n)
  end

  def events_special_page
    website.special_page(Communication::Website::Page::CommunicationAgenda)
  end

  def events_archive_special_page
    website.special_page(Communication::Website::Page::CommunicationAgendaArchive)
  end

  def permalink_for(l10n)
    return if l10n.nil?
    hugo = l10n.hugo(website)
    hugo.permalink
  end

  def base_events
    events = website.events.published_now_in(block.language)
    events = events.send(time) if time.in? AUTHORIZED_SCOPES
    events
  end

  def selected_events_all
    events = base_events.limit(quantity)
  end

  def selected_events_category
    events = base_events
    events = events.for_category(category) if category
    events = events.limit(quantity)
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
