class Osuny::Agenda::Composer
  attr_reader :website,
              :time_scope,
              :category,
              :include_parents,
              :include_children,
              :include_recurring,
              :quantity

  def initialize( website:,
                  time_scope:,
                  category: nil,
                  include_parents: true,
                  include_children: true,
                  include_recurring: true,
                  quantity: 1)
    @website = website
    @time_scope = time_scope
    @category = category
    @include_parents = include_parents
    @include_children = include_children
    @include_recurring = include_recurring
    @quantity = quantity
  end

  def to_array
    @to_array ||= sort(
      website_events_with_no_time_slots,
      federated_events_with_no_time_slots,
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

  def archive?
    time_scope == 'archive'
  end

  def website_events_with_no_time_slots
    events_filtered(website.events)
  end

  def federated_events_with_no_time_slots
    events_filtered(website.federated_communication_website_agenda_events)
  end

  def website_time_slots
    time_slots_filtered(website.time_slots)
  end

  def federated_time_slots
    time_slots_filtered(website.federated_communication_website_agenda_event_time_slots)
  end

  # Events

  def events_filtered(events)
    events = events.with_no_time_slots
                   .published_now_in(block.language)
    events = events_in_category(events)
    events = events_in_time(events)
    events = events_with_kinds(events)
    events.limit(quantity)
  end

  def events_in_time(events)
    events = events.public_send(time) if time.in?(AUTHORIZED_SCOPES)
    events = archive? ? events.ordered_desc : events.ordered_asc
    events
  end

  def events_in_category(events)
    events = events.for_category(category) if category
    events
  end

  def events_with_kinds(events)
    events = events.except_parent if !kind_parent
    events = events.except_children if !kind_child
    events = events.except_recurring if !kind_recurring
    events
  end

  # Time slots

  def time_slots_filtered(time_slots)
    # TODO
    time_slots
  end
end
