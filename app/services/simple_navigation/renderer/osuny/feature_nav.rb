module SimpleNavigation
  module Renderer
    module Osuny
      class FeatureNav < SimpleNavigation::Renderer::Base
        def render(item_container)
          html = '<div class="feature-nav">'
          item_container.items.each do |item|
            html += item.selected?  ? "<h1>#{item.name}</h1>"
                                    : "<a href=\"#{item.url}\">#{item.name}</a>"
          end
          html += '</div>'
          html.html_safe
        end
      end
    end
  end
end