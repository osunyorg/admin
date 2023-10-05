class Communication::Block::Template::Agenda < Communication::Block::Template::Base

  has_layouts [:grid, :list]

  has_component :description, :rich_text
  has_component :quantity, :number, options: 3
  has_component :time, :option, options: [:future_or_present, :future, :present, :archive]

  def selected_events
    @selected_events ||= events_with_time_scope
  end

  def allowed_for_about?
    website.present?
  end

  protected

  def events_with_time_scope
    events = block.about&.website
                          .events
                          .for_language(block.language)
                          .published
                          .limit(quantity)
    # Whitelist for security
    # (not very elegant though)
    case time
    when 'future_or_present'
      return events.future_or_present
    when 'future'
      return events.future
    when 'present'
      return events.present
    when 'archive'
      return events.archive
    else
      return events
    end
  end

end
