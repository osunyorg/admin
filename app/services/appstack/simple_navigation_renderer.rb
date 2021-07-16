class Appstack::SimpleNavigationRenderer < SimpleNavigation::Renderer::Base
  def render(item_container)
    SimpleNavigation.config.selected_class = 'active'
    content = '<ul class="sidebar-nav">'
    item_container.items.each do |item|
      content << make(item)
    end
    content << '</ul>'
    content.html_safe
  end

  protected

  def make(item)
    options = item.send :options
    icon = options[:icon]
    classes = item.html_options[:class]
    include_sub_navigation = consider_sub_navigation?(item)
    container = item.send :container
    level = container.send :level
    content = "
      <li class=\"sidebar-item #{ classes }\">"
    content += "<a href=\"#{ item.url }\" class=\"sidebar-link#{ ' collapsed' unless item.selected? }\""
    content += " data-bs-target=\"##{ item.key }\" data-bs-toggle=\"collapse\"" if include_sub_navigation
    content += ">"
    content += "<i class=\"fas fa-#{ options[:icon].to_s }\"></i>" if icon
    content += '<span class="align-middle">' if level == 1
    content += item.name
    content += '</span>' if level == 1
    content += '</a>'
    content += make_subnavigation(item, level) if include_sub_navigation
    content += '</li>'
    content
  end

  def make_subnavigation(item, level)
    content = "
      <ul id=\"#{ item.key }\" class=\"sidebar-dropdown list-unstyled #{item.selected? ? 'show' : 'collapse'}\">"
    content += render_sub_navigation_for(item)
    content += '
      </ul>'
    content
  end

end
