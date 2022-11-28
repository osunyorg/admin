class Osuny::SimpleNavigationRenderer < SimpleNavigation::Renderer::Base
  def render(item_container)
    content = '<ul class="sidebar-nav">'
    item_container.items.each do |item|
      content << make(item)
    end
    content << '</ul>'
    content.html_safe
  end

  protected

  def make(item)
    kind = item.send(:options)[:kind]
    kind == :header ? make_header(item)
                    : make_item(item)
  end

  def make_item(item)
    li = "<li class=\"sidebar-item #{ item.html_options[:class] } #{ ' disabled' unless item.url }\">"
    li += make_a(item)
    li += make_subnavigation(item) if consider_sub_navigation?(item)
    li += '</li>'
    li
  end

  def make_header(item)
    icon = item.send(:options)[:icon]
    header = ''
    header += '</div>'
    # header += "<i class=\"fas fa-#{ icon }\"></i>" if icon
    header += "<div class=\"col-md-4 col-lg-3\"><h2>#{item.name}</h2>"
    header
  end

  def make_a(item)
    icon = item.send(:options)[:icon]
    a = "<a href=\"#{ item.url }\" class=\"sidebar-link#{ item.selected? ? '' : ' collapsed' }\""
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
