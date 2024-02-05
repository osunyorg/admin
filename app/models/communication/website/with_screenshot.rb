module Communication::Website::WithScreenshot
  extend ActiveSupport::Concern
  
  included do
    has_one_attached :screenshot
  end
  
  def screenshot!
    screenshot_url = Screenshot.capture(url)
    downloaded_image = URI.open(screenshot_url)
    self.screenshot.attach(io: downloaded_image  , filename: "screenshot.png")
  end
end