class Communication::Website::Agenda::Planner
  attr_reader :website,
              :time_scope,
              :category,
              :language,
              :quantity,
              :include_parents,
              :include_children,
              :include_recurring

  def initialize( website:,
                  time_scope:,
                  category: nil,
                  language: nil,
                  quantity: 1,
                  include_parents: true,
                  include_children: true,
                  include_recurring: true)
    @website = website
    @time_scope = time_scope
    @category = category
    @quantity = quantity
    @language = language
    @include_parents = include_parents
    @include_children = include_children
    @include_recurring = include_recurring
  end

  def archive?
    time_scope == 'archive'
  end

  def to_array
    @to_array ||= sort(
      website_events,
      federated_events,
      website_time_slots,
      federated_time_slots,
    ).first(quantity)
  end

  protected

  def sort(*args)
    list = args.flatten
    list.sort_by! { |event_or_time_slot| event_or_time_slot.sorting_time }
    list.reverse! if archive?
    list
  end

  def website_events
    Communication::Website::Agenda::Planner::Events.new(
      self,
      website.events
    ).to_array
  end
  
  def federated_events
    Communication::Website::Agenda::Planner::Events.new(
      self,
      website.federated_communication_website_agenda_events
    ).to_array
  end

  def website_time_slots
    Communication::Website::Agenda::Planner::TimeSlots.new(
      self,
      website.time_slots
    ).to_array
  end

  def federated_time_slots
    Communication::Website::Agenda::Planner::TimeSlots.new(
      self,
      website.federated_communication_website_agenda_event_time_slots
    ).to_array
  end

end
