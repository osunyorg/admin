class Communication::Block::Template::Agenda < Communication::Block::Template::Base

  AUTHORIZED_SCOPES = [
    'future_or_present',
    'future',
    'present',
    'archive'
  ]

  has_layouts [:grid, :list, :large]

  has_component :description, :rich_text
  has_component :quantity, :number, options: 3
  has_component :time, :option, options: [:future_or_present, :future, :present, :archive]

  def selected_events
    @selected_events ||= events_with_time_scope
  end

  def dependencies
    selected_events
  end

  def allowed_for_about?
    website.present?
  end

  protected

  def events_with_time_scope
    events = website.events.for_language(block.language).published
    events = events.send(time) if time.in? AUTHORIZED_SCOPES
    events = events.limit(quantity)
  end

end
