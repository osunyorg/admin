class Osuny::SimpleNavigationRenderer < SimpleNavigation::Renderer::Base
  OPEN = "<div class=\"col-md-4 col-lg-3 mb-5\">"
  CLOSE = "</div>"

  attr_accessor :content, :index, :item

  def render(item_container)
    @content = ''
    @index = 0
    item_container.items.each do |item|
      @item = item
      build
      @index += 1
    end
    @content << CLOSE
    @content.html_safe
  end

  protected

  def build
    if @index.zero?
      @content << "#{OPEN}<h2>#{item_name_and_link}</h2><ul>"
    elsif item_is_header?
      @content << "</ul>#{CLOSE}#{OPEN}<h2>#{item_name_and_link}</h2><ul>"
    else
      @content << "<li>#{item_name_and_link}</li>"
    end
  end

  def item_is_header?
    item.send(:options)[:kind] == :header
  end

  def item_name_and_link
    item.url.present? ? "<a href=\"#{item.url}\">#{item.name}</a>"
                      : "<span>#{item.name}</span>"
  end
end
