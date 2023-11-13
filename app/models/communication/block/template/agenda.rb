class Communication::Block::Template::Agenda < Communication::Block::Template::Base

  AUTHORIZED_SCOPES = [
    'future_or_present',
    'future',
    'present',
    'archive'
  ]
  
  has_elements
  has_layouts [:grid, :list, :large]
  has_component :mode, :option, options: [:all, :category, :selection]
  has_component :category_id, :category
  has_component :description, :rich_text
  has_component :quantity, :number, options: 3
  has_component :time, :option, options: [:future_or_present, :future, :present, :archive]
  has_component :show_category, :boolean
  has_component :show_summary, :boolean
  has_component :show_status, :boolean

  def selected_events
    @selected_events ||= events_with_time_scope
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

  def events_with_time_scope
    events = website.events.for_language(block.language).published
    events = events.send(time) if time.in? AUTHORIZED_SCOPES
    events = events.limit(quantity)
  end

end
