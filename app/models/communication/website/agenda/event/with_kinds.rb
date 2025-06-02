module Communication::Website::Agenda::Event::WithKinds
  extend ActiveSupport::Concern

  included do
    MAX_DURATION = 1.year

    validate :no_child_before?, if: :kind_parent?
    validate :no_child_after?, if: :kind_parent?
    # validate :not_too_long # Uncomment when Rennes is ready

    before_validation :set_to_day
    after_save :manage_time_slots
    after_commit :touch_parent, if: :kind_child?

    scope :with_no_time_slots, -> { where.missing(:time_slots) }
    scope :who_can_have_children, -> { root.with_no_time_slots }
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

  protected

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
    same_day? ? manage_time_slots_same_day : manage_time_slots_multiple_days
  end

  def manage_time_slots_same_day
    time_slots.each do |time_slot|
      time_slot.set_date_to(from_day)
    end
  end

  def manage_time_slots_multiple_days
    time_slots.each do |time_slot|
      outside = time_slot.datetime < from_day || time_slot.datetime > to_day
      time_slot.destroy if outside
    end
  end

  def touch_parent
    parent.touch
  end
end
