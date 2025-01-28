class Osuny::SimpleNavigationRenderer < SimpleNavigation::Renderer::Base
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
    li = "<li class=\"nav-item p-0"
    li += " active" if item.selected?
    li += " dropend" if has_sub_navigation
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
    subnavigation = "<div class=\"dropdown-menu submenu bg-dark border-0\">"
    image = item.options[:image]
    if image.present?
      subnavigation += "<a href=\"#{item.url}\" class=\"submenu__image\">";
      subnavigation += ActionController::Base.helpers.image_tag image, class: 'card-img-top rounded-top', loading: :lazy
      subnavigation += "</a>";
    end
    subnavigation += "<ul class=\"pt-2\">"
    item.sub_navigation.items.each do |item|
      subnavigation += "<li>"
      if item.url.present?
        subnavigation += "<a href=\"#{ item.url }\" class=\"dropdown-item bg-dark\">#{item.name}</a>"
      else
        subnavigation += "<span class=\"dropdown-item bg-dark text-light\">#{item.name}</span>"
      end
      subnavigation += "</li>"
    end
    subnavigation += "</ul></div>"
    subnavigation
  end
end
