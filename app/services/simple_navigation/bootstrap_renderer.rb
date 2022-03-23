class SimpleNavigation::BootstrapRenderer < SimpleNavigation::Renderer::Base
  def render(item_container)
    content = '<ul class="nav">'
    item_container.items.each do |item|
      content << make(item)
    end
    content << '</ul>'
    content.html_safe
  end

  protected

  def make(item)
    li = "<li class=\"sidebar-item #{ item.html_options[:class] } #{ ' disabled' unless item.url }\">"
    li += make_a(item)
    li += make_subnavigation(item) if consider_sub_navigation?(item)
    li += '</li>'
    li
  end

  def make_item(item)
    li = "<li class=\"nav-item #{ item.html_options[:class] } #{ ' disabled' unless item.url }\">"
    li += make_a(item)
    li += make_subnavigation(item) if consider_sub_navigation?(item)
    li += '</li>'
    li
  end

  def make_a(item)
    icon = item.send(:options)[:icon]
    a = "<a href=\"#{ item.url }\" class=\"nav-link#{ item.selected? ? '' : ' collapsed' }\""
    a += " data-bs-target=\"##{ item.key }\" data-bs-toggle=\"collapse\"" if consider_sub_navigation?(item)
    a += ">"
    a += "<i class=\"fas fa-#{ icon }\"></i>" if icon
    a += "<span class=\"align-middle\">#{ item.name }</span></a>"
    a
  end

  def make_subnavigation(item)
    "<ul id=\"#{ item.key }\" class=\"sidebar-dropdown list-unstyled #{ item.selected? ? 'show' : 'collapse' }\">
      #{ render_sub_navigation_for item }
    </ul>"
  end
end
