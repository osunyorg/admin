# Instanciated only by Communication::Website::Agenda::Planner
class Communication::Website::Agenda::Planner::Events
  attr_reader :planner, :events

  def initialize(planner, events)
    @planner = planner
    @events = events
  end

  def to_array
    remove_time_slots!
    remove_drafts!
    filter_by_category!
    apply_time!
    filter_parent!
    filter_children!
    filter_recurring!
    limit_quantity!
    @events
  end

  protected

  # Time slots are managed separately
  def remove_time_slots!
    @events = @events.with_no_time_slots
  end

  def remove_drafts!
    @events = @events.published_now_in(planner.language)
  end
  
  def filter_by_category!
    return unless planner.category
    @events = @events.for_category(planner.category)
  end

  def apply_time!
    @events = @events.public_send(planner.time_scope)
    @events = planner.archive? ? @events.ordered_desc : @events.ordered_asc
  end

  def filter_parent!
    return if planner.include_parents
    @events = @events.except_parent
  end

  def filter_children!
    return if planner.include_children
    @events = @events.except_children
  end

  def filter_recurring!
    return if planner.include_recurring
    @events = @events.except_recurring
  end

  def limit_quantity!
    @events = @events.limit(planner.quantity)
  end

end
