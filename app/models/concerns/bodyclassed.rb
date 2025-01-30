# Needs `ancestors``
module Bodyclassed
  extend ActiveSupport::Concern

  # La page actuelle a les bodyclass classe1 et classe2 ("classe1 classe2")
  # Les différents ancêtres ont les classes home, bodyclass et secondclass
  # -> "page-classe1 page-classe2 ancestor-home ancestor-bodyclass ancestor-secondclass"
  def best_bodyclass
    classes = []
    classes += add_prefix_to_classes(bodyclass.split(' '), 'page') unless bodyclass.blank?
    classes += add_prefix_to_classes(ancestor_classes, 'ancestor') unless ancestor_classes.blank?
    classes.join(' ')
  end

  protected

  # ["class1", "class2"], "page" -> ["page-class1", "page-class2"]
  def add_prefix_to_classes(classes, prefix)
    classes.map { |single_class| "#{prefix}-#{single_class}" }
  end

  # ["class1", "class2", "class3 class4"] -> ["class1", "class2", "class3", "class4"]
  def ancestor_classes
    @ancestor_classes ||= ancestors.pluck(:bodyclass)
                                   .compact_blank
                                   .join(' ')
                                   .split(' ')
                                   .compact_blank
  end
end