class Admin::Communication::Websites::PreviewController < Admin::Communication::Websites::ApplicationController
  def style
    render  body: @website.preview_style,
            content_type: "text/css"
  end

  def assets
    path = request.path.partition('/assets').last
    url = "#{@website.url}/assets#{path}"
    data = URI.parse(url).open.read
    render  body: data,
            content_type: request.format.to_s
  rescue
  end
end