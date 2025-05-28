module Communication::Website::Agenda::Event::WithKinds
  extend ActiveSupport::Concern

  included do
    MAX_DURATION = 1.year

    validate :no_child_before?, if: :kind_parent?
    validate :no_child_after?, if: :kind_parent?
    validate :not_too_long

    before_validation :set_to_day, if: :kind_child?
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

  def not_too_long
    max_duration_in_days = MAX_DURATION / 1.day
    if duration_in_days > max_duration_in_days
      max_end_date = from_day + max_duration_in_days
      errors.add(:to_day, :too_long, max_end_date: max_end_date)
    end
  end

  def set_to_day
    self.to_day = self.from_day
  end

  def touch_parent
    parent.touch
  end
end
