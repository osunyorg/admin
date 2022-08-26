class SimpleNavigation::BootstrapRenderer < SimpleNavigation::Renderer::Base
  def render(item_container)
    content = '<ul class="navbar-nav">'
    item_container.items.each do |item|
      content << make(item)
    end
    content << '</ul>'
    content.html_safe
  end

  protected

  def make(item)
    has_sub_navigation = consider_sub_navigation?(item)
    li = "<li class=\"nav-item"
    li += " active" if item.selected?
    li += " dropdown" if has_sub_navigation
    li += "\">"
    li += make_a(item)
    li += make_subnavigation(item) if has_sub_navigation
    li += '</li>'
    li
  end

  def make_a(item)
    has_sub_navigation = consider_sub_navigation?(item)
    a = "<a href=\"#{ item.url }\" class=\"nav-link"
    a += " dropdown-toggle" if has_sub_navigation
    a += "\""
    a += " data-bs-toggle=\"dropdown\" aria-expanded=\"false\"" if has_sub_navigation
    a += ">"
    a += item.name
    a += "</a>"
    a
  end

  def make_subnavigation(item)
    ul = "<ul class=\"dropdown-menu\">"
    item.sub_navigation.items.each do |i|
      ul += "<li>"
      ul += "<a href=\"#{ i.url }\" class=\"dropdown-item\">"
      ul += i.name
      ul += "</a>"
      ul += "</li>"
    end
    ul += "</ul>"
    ul
  end
end
