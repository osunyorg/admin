module ApplicationHelper

  def controller_class
    "#{controller_name.gsub('/', '--')}"
  end

  def body_classes
    classes = "controller-#{controller_class}"
    classes += " action-#{action_name}"
    classes += " #{controller_class}-#{action_name}"
    classes
  end

end
