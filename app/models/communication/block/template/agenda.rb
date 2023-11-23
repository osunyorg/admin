class Communication::Block::Template::Agenda < Communication::Block::Template::Base

  AUTHORIZED_SCOPES = [
    'future_or_current',
    'future',
    'current',
    'archive'
  ]

  has_elements
  has_layouts [:grid, :list, :large]
  has_component :mode, :option, options: [:all, :category, :selection]
  has_component :category_id, :category
  has_component :description, :rich_text
  has_component :quantity, :number, options: 3
  has_component :time, :option, options: AUTHORIZED_SCOPES
  has_component :show_category, :boolean
  has_component :show_summary, :boolean
  has_component :show_status, :boolean

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

  protected

  def base_events
    events = website.events.for_language(block.language).published
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

end
