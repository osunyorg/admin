# Instanciated only by Communication::Website::Agenda::Planner
class Communication::Website::Agenda::Planner::TimeSlots
  attr_reader :planner, :time_slots

  def initialize(planner, time_slots)
    @planner = planner
    @time_slots = time_slots
  end

  def to_array
    remove_drafts!
    filter_by_category!
    apply_time!
    limit_quantity!
    @time_slots
  end

  protected

  def remove_drafts!
    @time_slots = @time_slots.published_now_in(planner.language)
  end
  
  def filter_by_category!
    return unless planner.category
    @time_slots = @time_slots.for_category(planner.category)
  end

  def apply_time!
    @time_slots = @time_slots.public_send(planner.time_scope)
    @time_slots = planner.archive? ? @time_slots.ordered_desc : @time_slots.ordered_asc
  end

  def limit_quantity!
    @time_slots = @time_slots.limit(planner.quantity)
  end

end
