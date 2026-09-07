module Communication::Website::Agenda::Event::WithKinds
  extend ActiveSupport::Concern

  included do
    MAX_DURATION = 1.year

    KIND_SIMPLE = 'simple'
    KIND_RECURRING = 'recurring'
    KIND_PARENT = 'parent'

    validate :no_child_before?, if: :kind_parent?
    validate :no_child_after?, if: :kind_parent?
    validate :in_parent_dates?, if: :kind_child?

    # validate :not_too_long # Uncomment when Rennes is ready

    before_validation :set_to_day
    after_save :manage_time_slots
    after_commit :touch_parent, if: :kind_child?

    scope :with_no_time_slots, -> { where.missing(:time_slots) }
    scope :who_can_have_children, -> { root.with_no_time_slots }

    scope :except_parent, -> { where.missing(:children) }
    scope :except_children, -> { where(parent_id: nil) }
    scope :except_recurring, -> { where(
                                    "(?) <= 1",
                                    Communication::Website::Agenda::Event::TimeSlot
                                      .select("COUNT(*)")
                                      .where("communication_website_agenda_event_time_slots.communication_website_agenda_event_id = communication_website_agenda_events.id")
                                  )
                                }
  end

  def kind
    # Le kind child peut être simple ou recurring, c'est une modélisation étrange
    if kind_simple?
      KIND_SIMPLE
    elsif kind_recurring?
      KIND_RECURRING
    else
      KIND_PARENT
    end
  end

  def kind_simple?
    children.none? && !multiple_time_slots?
  end

  def kind_recurring?
    children.none? && multiple_time_slots?
  end

  def kind_parent?
    children.any?
  end

  def kind_child?
    parent.present? && parent.persisted?
  end

  def can_have_children?
    parent.nil? && time_slots.none?
  end

  def can_have_time_slots?
    children.none?
  end

  def has_time_slots?
    time_slots.any?
  end

  def multiple_time_slots?
    time_slots.count > 1
  end

  def can_set_parent?
    # parent can be set only if there's at least a good candidate
    possible_parents.any? &&
    (
      can_change_parent? ||
      can_become_child?
    )
  end

  def possible_parents
    @possible_parents ||= website.events
                                 .who_can_have_children
                                 .current_on(from_day)
                                 .where.not(id: id)
                                 .or(website.events.where(id: parent_id))
  end

  protected

  def can_change_parent?
    parent.present?
  end

  def can_become_child?
    # because events can become children
    parent.nil? &&
    # but only same day events, as multi-days events splits children by day
    single_day? &&
    # and never children of children
    !kind_parent?
  end

  def no_child_before?
    if children.where('from_day < ?', self.from_day).any?
      errors.add(:from_day, :events_before)
    end
  end

  def no_child_after?
    if children.where('to_day > ?', self.to_day).any?
      errors.add(:to_day, :events_after)
    end
  end

  def in_parent_dates?
    return if from_day.nil? || to_day.nil?

    if from_day < parent.from_day || to_day > parent.to_day
      errors.add(:parent_id, :outside_parent_dates)
    end
  end

  # def not_too_long
  #   max_duration_in_days = MAX_DURATION / 1.day
  #   if duration_in_days > max_duration_in_days
  #     max_end_date = from_day + max_duration_in_days
  #     errors.add(:to_day, :too_long, max_end_date: max_end_date)
  #   end
  # end

  def set_to_day
    if kind_child?
      # Always the same day for children
      self.to_day = self.from_day
    else
      # Either it's explicitly set, or it's the same as the start date (no empty to_day)
      self.to_day ||= self.from_day
    end
  end

  def manage_time_slots
    single_day? ? manage_time_slots_same_day : manage_time_slots_multiple_days
  end

  def manage_time_slots_same_day
    return unless saved_change_to_from_day?
    time_slots.each do |time_slot|
      time_slot.set_date_to(from_day)
    end
  end

  def manage_time_slots_multiple_days
    return unless saved_change_to_from_day? || saved_change_to_to_day?
    time_slots.each do |time_slot|
      outside = time_slot.datetime < from_day || time_slot.datetime > to_day
      time_slot.destroy if outside
    end
  end

  def touch_parent
    parent.touch
  end
end
