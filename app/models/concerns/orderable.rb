module Orderable
  extend ActiveSupport::Concern

  included do
    before_create :set_position, if: -> (object) { object.position.nil? }
    scope :ordered, -> (language = nil) { order(position: :asc) }
  end

  protected

  def set_position
    self.position = last_ordered_element.nil? ? 1 : last_ordered_element.position + 1
  end

  def last_ordered_element
    self.class.unscoped.where(university_id: university_id).ordered.last
  end
end
