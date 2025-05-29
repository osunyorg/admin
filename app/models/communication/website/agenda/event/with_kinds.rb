module Communication::Website::Agenda::Event::WithKinds
  extend ActiveSupport::Concern

  included do
    before_validation :same_to_day, if: :kind_child?

    after_commit :touch_parent_if_child

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
    parent.present?
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

  def touch_parent_if_child
    return unless kind_child? && parent.persisted?
    parent.touch
  end

  def same_to_day
    self.to_day = self.from_day
  end
end
