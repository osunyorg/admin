class Appstack::BreadcrumbsOnRailsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    html = '<nav aria-label="breadcrumb"><ol class="breadcrumb m-0">'
    html += @elements.collect do |element|
      render_element(element)
    end.join('')
    html += '</ol></nav>'
    html
  end

  def render_element(element)
    if element.path == nil
      content = compute_name(element)
    else
      content = @context.link_to_unless_current(compute_name(element), compute_path(element), element.options)
    end
    classes = 'breadcrumb-item'
    current_page = @context.current_page? compute_path(element)
    classes += ' active' if current_page
    "<li class=\"#{classes}\"#{' aria-current="page"' if current_page}>#{content}</li>"
  end
end
