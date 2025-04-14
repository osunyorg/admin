module Admin::ButtonsHelper

  def button_classes(additional = '', **options)
    classes = "btn btn-light #{additional}"
    classes += ' disabled' if options[:disabled]
    classes
  end

  def button_classes_major(additional = '', **options)
    classes = "btn btn-primary mb-2 #{additional}"
    classes += ' disabled' if options[:disabled]
    classes
  end

  def button_classes_danger(**options)
    classes = 'btn btn-danger'
    classes += ' disabled' if options[:disabled]
    classes
  end

  def button_advanced(&block)
    content = capture(&block)
    return if content.blank?
    id = SecureRandom.hex(10)
    html = "<button class=\"btn btn-light\" type=\"button\" data-bs-toggle=\"dropdown\" data-bs-target=\"##{id}\" aria-controls=\"menu\" aria-expanded=\"false\" aria-label=\"Toggle actions\">"
    html += lucide_icon(:settings) 
    html += "</button>"
    html += "<div class=\"dropdown-menu border-0 bg-light mt-2 p-3\" id=\"#{id}\" style=\"min-width: 120px\">"
    html += capture(&block)
    html += "</div>"
    raw html
  end
end